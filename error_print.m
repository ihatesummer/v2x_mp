allErrors_history = [];
sensorNoise = 0;
variance_d = 1; % (D_error*100)/100
variance_theta = (pi / 180 * 3)^2; % (A_error*10)/10,  degree;
nVehicles = 10;
nIterations = 10;
anchor = round(nVehicles / 2);

fid = fopen('allErrors_history.txt', 'w');
type1_1 = ['          abs_avg_total       abs_max_total      abs_min_total'];
type1_2 = [' abs_avg_anchor      abs_max_anchor      abs_min_anchor'];
type1_3 = ['abs_avg_agent       abs_max_agent       abs_min_agent'];

type2_1 = ['rel_avg_total        rel_max_total       rel_min_total'];
type2_2 = ['rel_avg_anchor      rel_max_anchor      rel_min_anchor'];
type2_3 = ['rel_avg_agent      rel_max_agent      rel_min_agent'];

fprintf(fid, '%s      %s      %s      %s      %s      %s', type1_1, type1_2, type1_3, type2_1, type2_2, type2_3);
fprintf(fid, '\r\n');

distanceToAnchor = 10;
nRepeat = 20; % for obtaining average performance
for d = 0:5:distanceToAnchor

    for a = 1:nRepeat

        variation_movement_x = 0.1;
        variation_movement_y = 1; 
        timeInterval = 0.1;
        avgVelocity_x_all = 0;
        avgVelocity_y_vehicle1to2 = 36;
        avgVelocity_y_vehicle4to5 = 36;
        avgVelocity_y_vehicle3 = 36;
        avgVelocity_y_anchor = 36;

        currentPositions_y = zeros(10,1);
        currentPositions_y(anchor) = d;
        currentPositions_y = currentPositions_y + randn(nVehicles, 1);
        currentPositions_x = [1 1 2 2 3 3 4 4 5 5]' * 3.5; %3.5: width of the lanes, in meter
        currentPositions = [currentPositions_x currentPositions_y];

        distances = squareform(pdist(currentPositions));

        distances_observed = distances + ...
            sqrt(variance_d) * randn(size(distances)); %z_ijn
        distances_observed(1:1 + size(distances_observed, 1):end) = 0; %eliminating diagonal entries

        coorinateDifferences = repmat(permute(currentPositions, [1 3 2]), [1 nVehicles]) ...
        - repmat(permute(currentPositions, [3 1 2]), [nVehicles 1]);
        %coorinateDifferences(:,:,1) for x-axis, coorinateDifferences(:,:,2) for y-axis
        aoa = atan(coorinateDifferences(:, :, 2) ./ coorinateDifferences(:, :, 1)) ...
            + (coorinateDifferences(:, :, 1) < 0) * pi;
        aoa(1:1 + size(aoa, 1):end) = 0; %eliminating diagonal entries

        aoa_observed = aoa + ...
            sqrt(variance_theta) * randn(size(aoa)); %theta_ijn
        aoa_observed(1:nVehicles + 1:end) = 0;

    
        currentPositions_history(:, :, 1) = currentPositions;

        distances_history(:, :, 1) = distances;
        distances_observed_history(:, :, 1) = distances_observed;
    
        aoa_history(:, :, 1) = aoa;
        aoa_observed_history(:, :, 1) = aoa_observed;

        %Gaussian approximation
        %initial message parameter definition (initial belief)
        beliefMean = currentPositions + sqrt(variance_d) * randn(size(currentPositions)) / 2; 
        beliefMean_history(:, :, 1) = beliefMean;

        x = squareform(pdist(beliefMean_history(:, 1, 1)));
        y = squareform(pdist(beliefMean_history(:, 2, 1)));
        distances_belief_history(:, :, 1) = sqrt(x.^2 + y.^2);

        x = squareform(pdist(currentPositions_history(:, 1, 1)));
        y = squareform(pdist(currentPositions_history(:, 2, 1)));
        distances_actual_history(:, :, 1) = sqrt(x.^2 + y.^2);

        relDiff = distances_actual_history(:, :, 1) - distances_belief_history(:, :, 1);
        relError_all(1) = mean(abs(relDiff), 'all');

        absDiff = currentPositions_history(:, :, 1) - beliefMean_history(:, :, 1);
        absDiff_L2 = sqrt(sum(absDiff.^2, 2)); %L2 norm
        absError_all(1) = mean(absDiff_L2);

        beliefVariance = variance_d * ones(size(currentPositions));
        beliefVariance_history(:, :, 1) = beliefVariance;

        ii = 0;

        while(true)
            ii = ii + 1;
        
            % factor to variable messge update (f_i --> x_{i,n})
            for j = 1:nVehicles
    
                if j == anchor
                    fi2xin_mean(anchor, :) = beliefMean(anchor, :) + [avgVelocity_x_all avgVelocity_y_anchor] * timeInterval;
                else
    
                    if currentPositions(j, 1) < 8.5
                        fi2xin_mean(j, :) = beliefMean(j, :) + [avgVelocity_x_all avgVelocity_y_vehicle1to2] * timeInterval;
                    elseif currentPositions(j, 1) >= 8.5 && currentPositions(j, 1) < 13
                        fi2xin_mean(j, :) = beliefMean(j, :) + [avgVelocity_x_all avgVelocity_y_vehicle3] * timeInterval;
                    else
                        fi2xin_mean(j, :) = beliefMean(j, :) + [avgVelocity_x_all avgVelocity_y_vehicle4to5] * timeInterval;
                    end
    
                end
    
            end
    
            fi2xin_variance = beliefVariance + repmat([variation_movement_x variation_movement_y], [size(beliefVariance, 1) 1]);
    
            intbelmean1 = fi2xin_mean;
            intbelvar1 = fi2xin_variance;
    
            xin2fij_mean = intbelmean1;
            xin2fij_variance = intbelvar1;
    
            fij2xin_mean = zeros([size(distances_observed), 2]);
            fij2xin_variance = zeros([size(distances_observed), 2]);
            
            % cooperative positioning (intervehicular iteration)
            for iter = 1:nIterations
                % factor to variable message update (f_{i,j} --> x_{i,n})
                for v1 = 1:nVehicles
                    sum_fij2xin_mean = [0 0];
                    sum_fij2xin_variance = [0 0];
    
                    for v2 = 1:nVehicles
    
                        if v1 ~= v2 && abs(distances_observed(v1, v2)) > eps
                            x = variance_d * cos(aoa_observed(v1, v2))^2 + ...
                                distances_observed(v1, v2)^2 * variance_theta * ...
                                sin(aoa_observed(v1, v2))^2;
                            y = variance_d * sin(aoa_observed(v1, v2))^2 + ...
                                distances_observed(v1, v2)^2 * variance_theta * ...
                                cos(aoa_observed(v1, v2))^2;
                            fij2xin_variance(v1, v2, :) = xin2fij_variance(v2, :) + [x y];
    
                            sum_fij2xin_mean = sum_fij2xin_mean + squeeze(fij2xin_mean(v1, v2, :) ./ fij2xin_variance(v1, v2, :)).';
                            sum_fij2xin_variance = sum_fij2xin_variance + squeeze(1 ./ fij2xin_variance(v1, v2, :)).';
    
                            if v2 ~= anchor
                                fij2xin_mean(v1, v2, :) = xin2fij_mean(v2, :) + ...
                                    distances_observed(v1, v2) * ...
                                    [cos(aoa_observed(v1, v2)) sin(aoa_observed(v1, v2))];
                            else % i.e., v2 is anchor
                                fij2xin_mean(v1, v2, :) = currentPositions(v2, :) + ...
                                    distances_observed(v1, v2) * ...
                                    [cos(aoa_observed(v1, v2)) sin(aoa_observed(v1, v2))];
                            end
    
                        end %condition_ v1 ~= v2 && abs(distances_observed(v1,v2)) > eps
    
                    end %loop_ v2 = 1:nVehicles
    
                    intbelvar1(v1, :) = 1 ./ (1 ./ fi2xin_variance(v1, :) + sum_fij2xin_variance);
                    intbelmean1(v1, :) = intbelvar1(v1, :) .* (fi2xin_mean(v1, :) ./ fi2xin_variance(v1, :) + sum_fij2xin_mean);
                end %loop_ v1 = 1:nVehicles
    
                xin2fij_mean = intbelmean1;
                xin2fij_variance = intbelvar1;
            end %loop_ iter = 1:nIterations
    
            beliefMean = intbelmean1;
            beliefVariance = intbelvar1;
            beliefMean_history(:, :, ii + 1) = beliefMean;
            beliefVariance_history(:, :, ii + 1) = beliefVariance;
    
            currentPositions_history(:, :, ii + 1) = currentPositions;
            
            distances = squareform(pdist(currentPositions));
            distances_history(:, :, ii + 1) = distances;

            distances_observed = distances + ...
                sqrt(variance_d) * randn(size(distances)); %z_ijn
            distances_observed(1:1 + size(distances_observed, 1):end) = 0; %eliminating diagonal entries
            distances_observed_history(:, :, ii + 1) = distances_observed; % history of observed distance

            coorinateDifferences = repmat(permute(currentPositions, [1 3 2]), [1 nVehicles]) ...
                - repmat(permute(currentPositions, [3 1 2]), [nVehicles 1]);
            %coorinateDifferences(:,:,1) for x-axis, coorinateDifferences(:,:,2) for y-axis
            aoa = atan(coorinateDifferences(:, :, 2) ./ coorinateDifferences(:, :, 1)) ...
                + (coorinateDifferences(:, :, 1) < 0) * pi;
            aoa(1:1 + size(aoa, 1):end) = 0; %eliminating diagonal entries
            aoa_history(:, :, ii + 1) = aoa;

            aoa_observed = aoa + sqrt(variance_theta) * randn(size(aoa)); %theta_ijn
            aoa_observed(1:nVehicles + 1:end) = 0; %eliminating diagonal entries
            aoa_observed_history(:, :, ii + 1) = aoa_observed;

            for j = 1:nVehicles

                if j == anchor
                    currentPositions(anchor, :) = currentPositions(anchor, :) + ...
                        [avgVelocity_x_all avgVelocity_y_anchor] * timeInterval;
                else
    
                    if currentPositions(j, 1) < 8.5
                        currentPositions(j, :) = currentPositions(j, :) + ...
                            [avgVelocity_x_all avgVelocity_y_vehicle1to2] * timeInterval;
                    elseif currentPositions(j, 1) >= 8.5 && currentPositions(j, 1) < 13
                        currentPositions(j, :) = currentPositions(j, :) + ...
                            [avgVelocity_x_all avgVelocity_y_vehicle3] * timeInterval;
                    else
                        currentPositions(j, :) = currentPositions(j, :) + ...
                            [avgVelocity_x_all avgVelocity_y_vehicle4to5] * timeInterval;
                    end
    
                end
    
            end

            %relative error
            x = repmat(beliefMean_history(:, 1, ii + 1), [1 nVehicles]) - repmat(beliefMean_history(:, 1, ii + 1).', [nVehicles 1]);
            y = repmat(beliefMean_history(:, 2, ii + 1), [1 nVehicles]) - repmat(beliefMean_history(:, 2, ii + 1).', [nVehicles 1]);
            distances_belief_history(:, :, ii + 1) = sqrt(x.^2 + y.^2);

            x = repmat(currentPositions_history(:, 1, ii + 1), [1 nVehicles]) - repmat(currentPositions_history(:, 1, ii + 1).', [nVehicles 1]);
            y = repmat(currentPositions_history(:, 2, ii + 1), [1 nVehicles]) - repmat(currentPositions_history(:, 2, ii + 1).', [nVehicles 1]);
            distances_actual_history(:, :, ii + 1) = sqrt(x.^2 + y.^2);

            for_error = abs(distances_actual_history(:, :, ii + 1) - distances_belief_history(:, :, ii + 1));
            for_error_agent = for_error(1, :);

            for j = 2:nVehicles

                if j == anchor
                    for_error_anchor = for_error(anchor, :);
                else
                    for_error_agent = horzcat(for_error_agent, for_error(j, :));
                end

            end

            relError_all(ii + 1) = mean(for_error, 'all');
            relError_all_avg = sum(relError_all) / ii;
            relError_all_max = max(relError_all);
            relError_all_min = min(relError_all);

            relError_anchor(ii + 1) = mean(for_error_anchor, 'all');
            relError_anchor_avg = sum(relError_anchor) / ii;
            relError_anchor_max = max(relError_anchor);
            relError_anchor_min = min(relError_anchor(2:ii + 1));

            relError_agent(ii + 1) = mean(for_error_agent, 'all');
            relError_agent_avg = sum(relError_agent) / ii;
            relError_agent_max = max(relError_agent);
            relError_agent_min = min(relError_agent(2:ii + 1));

            absError_all(ii + 1) = mean(sqrt(sum((currentPositions_history(:, :, ii + 1) - beliefMean_history(:, :, ii + 1)).^2, 2)), 1);
            absError_all_avg = sum(absError_all) / ii;
            absError_all_max = max(absError_all);
            absError_all_min = min(absError_all);

            absError_anchor(ii + 1) = (sqrt(sum(currentPositions_history(anchor, :, ii + 1) - beliefMean_history(anchor, :, ii + 1)).^2));
            absError_anchor_avg = sum(absError_anchor) / ii;
            absError_anchor_max = max(absError_anchor);
            absError_anchor_min = min(absError_anchor(2:ii + 1));

            for_abs_error = (currentPositions_history(:, :, ii + 1) - beliefMean_history(:, :, ii + 1)).^2;
            for_abs_error(anchor, :) = 0;
            absError_agent(ii + 1) = (sum(sqrt(sum(for_abs_error, 2)), 1)) / (nVehicles - length(anchor));
            absError_agent_avg = sum(absError_agent) / ii;
            absError_agent_max = max(absError_agent);
            absError_agent_min = min(absError_agent(2:ii + 1));

            if ii == 1000%how long? 15min
                break
            end

        end

        absError_all = [absError_all_avg, absError_all_max, absError_all_min];
        absError_anchor = [absError_anchor_avg, absError_anchor_max, absError_anchor_min];
        absError_agent = [absError_agent_avg, absError_agent_max, absError_agent_min];
        relError_all = [relError_all_avg, relError_all_max, relError_all_min];
        relError_anchor = [relError_anchor_avg, relError_anchor_max, relError_anchor_min];
        relError_agent = [relError_agent_avg, relError_agent_max, relError_agent_min];
        allErrors = horzcat(absError_all, absError_anchor, absError_agent, relError_all, relError_anchor, relError_agent);
        allErrors_history = [allErrors_history; allErrors];

    end
 
end

for mm = 1:length(0:5:distanceToAnchor)*length(1:nRepeat)
    fprintf(fid, '%20f', allErrors_history(mm, :));
    fprintf(fid, '\r\n');
end
fclose(fid);

%columns of all saved .mat files: average / max / min
absError_hist_all = allErrors_history(:,1:3);
absError_hist_anchor = allErrors_history(:,4:6);
absError_hist_agent = allErrors_history(:,7:9);
relError_hist_all = allErrors_history(:,10:12);
relError_hist_anchor = allErrors_history(:,13:15);
relError_hist_agent = allErrors_history(:,16:18);
save('absError_hist_all.mat','absError_hist_all')
save('absError_hist_anchor.mat','absError_hist_anchor')
save('absError_hist_agent.mat','absError_hist_agent')
save('relError_hist_all.mat','relError_hist_all')
save('relError_hist_anchor.mat','relError_hist_anchor')
save('relError_hist_agent.mat','relError_hist_agent')