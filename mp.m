sensorNoise = 0;
variance_d = 1; % (D_error*100)/100

if crlb_loaded
    % original .mat data range: -90deg ~ 90deg, with 0.01deg interval
    % Assuming symmetry, extend the range to -90deg ~ 270deg
    crlb = [crlb; crlb]; 
    variance_theta = crlb;
    crlb_loaded = true;
else
    variance_theta = (pi / 180 * 3)^2;
end

nVehicles = 10;
nIterations = 10;
anchor = round(nVehicles / 2);

variation_movement_x = 0.1;
variation_movement_y = 1;
timeInterval = 0.1;

% TODO turn below variables into array
avgVelocity_x_all = 0;
avgVelocity_y_vehicle1to2 = 36;
avgVelocity_y_vehicle4to5 = 36;
avgVelocity_y_vehicle3 = 36;
avgVelocity_y_anchor = 36;

distanceToAnchor_max = 14;
distanceToAnchor_interval = 1;
distanceToAnchor = 0:distanceToAnchor_interval:distanceToAnchor_max;

nRepeat = 1000; % for obtaining average performance

ii_max = 1000; % TODO findout what this exactly is, then rename this.

allErrors_history = zeros(length(distanceToAnchor) * nRepeat, 18);
allErrors_history_saveIndex = 0;

for d = distanceToAnchor
    for r = 1:nRepeat
        allErrors_history_saveIndex = allErrors_history_saveIndex + 1;
        
        currentPositions_y = zeros(10, 1);
        currentPositions_y(anchor) = d;
        currentPositions_y = currentPositions_y + randn(nVehicles, 1);
        currentPositions_x = [1 1 2 2 3 3 4 4 5 5]' * 3.5; %3.5: width of the lanes, in meter
        currentPositions = [currentPositions_x currentPositions_y];

        distances = squareform(pdist(currentPositions));

        distances_observed = distances + sqrt(variance_d) * randn(size(distances)); %z_ijn
        distances_observed(1:1 + size(distances_observed, 1):end) = 0; %eliminating diagonal entries
        
        %coorinateDifferences(:,:,1) for x-axis, coorinateDifferences(:,:,2) for y-axis
        coorinateDifferences = repmat(permute(currentPositions, [1 3 2]), [1 nVehicles]) - repmat(permute(currentPositions, [3 1 2]), [nVehicles 1]);
        % atan's range: -pi~pi
        aoa = atan(coorinateDifferences(:, :, 2) ./ coorinateDifferences(:, :, 1));
        % to receive appropriate cos(aoa), add pi if x-axis difference < 0
        aoa = aoa + (coorinateDifferences(:, :, 1) < 0) * pi; 
        aoa(1:1 + size(aoa, 1):end) = 0; %eliminating diagonal entries

        if crlb_loaded
            aoa_crlb_index = int32((aoa + pi / 2) ./ (2*pi) .* 3601 + 1);
            variance_theta_crlb = zeros(size(aoa_crlb_index));
            for idx = 1:numel(aoa_crlb_index)
                if aoa_crlb_index(idx) ~= 0
                    variance_theta_crlb(idx) = variance_theta(aoa_crlb_index(idx));
                end
            end
            aoa_observed = aoa + sqrt(variance_theta_crlb) .* randn(size(aoa)); %theta_ijn
            aoa_observed(1:nVehicles + 1:end) = 0;
        else
            aoa_observed = aoa + sqrt(variance_theta) * randn(size(aoa)); %theta_ijn
            aoa_observed(1:nVehicles + 1:end) = 0;
        end
        
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

        relError_all = zeros(1, ii_max + 1);
        relError_anchor = zeros(1, ii_max + 1);
        relError_agent = zeros(1, ii_max + 1);
        absError_all = zeros(1, ii_max + 1);
        absError_anchor = zeros(1, ii_max + 1);
        absError_agent = zeros(1, ii_max + 1);

        relDiff = distances_actual_history(:, :, 1) - distances_belief_history(:, :, 1);
        relError_all(1) = mean(abs(relDiff), 'all');

        absDiff = currentPositions_history(:, :, 1) - beliefMean_history(:, :, 1);
        absDiff_L2 = sqrt(sum(absDiff.^2, 2)); %L2 norm
        absError_all(1) = mean(absDiff_L2);

        beliefVariance = variance_d * ones(size(currentPositions));
        beliefVariance_history(:, :, 1) = beliefVariance;

        ii = 0;
            
        while (true)
            ii = ii + 1;

            % factor to variable messge update (f_i --> x_{i,n})
            fi2xin_mean = zeros(nVehicles, 2);
            
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
                            if crlb_loaded
                                x = variance_d * cos(aoa_observed(v1, v2))^2 + ...
                                    distances_observed(v1, v2)^2 * variance_theta_crlb(v1, v2) * sin(aoa_observed(v1, v2))^2;
                                y = variance_d * sin(aoa_observed(v1, v2))^2 + ...
                                    distances_observed(v1, v2)^2 * variance_theta_crlb(v1, v2) * cos(aoa_observed(v1, v2))^2;
                            else
                                x = variance_d * cos(aoa_observed(v1, v2))^2 + ...
                                    distances_observed(v1, v2)^2 * variance_theta * sin(aoa_observed(v1, v2))^2;
                                y = variance_d * sin(aoa_observed(v1, v2))^2 + ...
                                    distances_observed(v1, v2)^2 * variance_theta * cos(aoa_observed(v1, v2))^2;
                            end

                            fij2xin_variance(v1, v2, :) = xin2fij_variance(v2, :) + [x y];

                            sum_fij2xin_mean = sum_fij2xin_mean + squeeze(fij2xin_mean(v1, v2, :) ./ fij2xin_variance(v1, v2, :)).';
                            sum_fij2xin_variance = sum_fij2xin_variance + squeeze(1 ./ fij2xin_variance(v1, v2, :)).';

                            if v2 ~= anchor
                                fij2xin_mean(v1, v2, :) = xin2fij_mean(v2, :) + ...
                                    distances_observed(v1, v2) * ...
                                    [cos(aoa_observed(v1, v2)) sin(aoa_observed(v1, v2))];
                            else
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
            
            coorinateDifferences = repmat(permute(currentPositions, [1 3 2]), [1 nVehicles]) - repmat(permute(currentPositions, [3 1 2]), [nVehicles 1]);
            %coorinateDifferences(:,:,1) for x-axis, coorinateDifferences(:,:,2) for y-axis
            aoa = atan(coorinateDifferences(:, :, 2) ./ coorinateDifferences(:, :, 1)) + (coorinateDifferences(:, :, 1) < 0) * pi;
            aoa(1:1 + size(aoa, 1):end) = 0; %eliminating diagonal entries
            aoa_history(:, :, ii + 1) = aoa;
            
            if crlb_loaded
                aoa_crlb_index = int32((aoa + pi / 2) ./ (2*pi) .* 3601 + 1);
                for idx = 1:numel(aoa_crlb_index)
                    if aoa_crlb_index(idx) ~= 0
                        variance_theta_crlb(idx) = variance_theta(aoa_crlb_index(idx));
                    end
                end
                aoa_observed = aoa + sqrt(variance_theta_crlb) .* randn(size(aoa)); %theta_ijn
                aoa_observed(1:nVehicles + 1:end) = 0;
            else
                aoa_observed = aoa + sqrt(variance_theta) * randn(size(aoa)); %theta_ijn
                aoa_observed(1:nVehicles + 1:end) = 0; %eliminating diagonal entries
            end
            
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
            for_error_anchor = for_error(anchor, :);
            for_error_agent = for_error;
            for_error_agent(anchor,:) = [];

            relError_all(ii + 1) = mean(for_error, 'all');

            relError_anchor(ii + 1) = mean(for_error_anchor, 'all');

            relError_agent(ii + 1) = mean(for_error_agent, 'all');

            absError_all(ii + 1) = mean(sqrt(sum((currentPositions_history(:, :, ii + 1) - beliefMean_history(:, :, ii + 1)).^2, 2)), 1);

            absError_anchor(ii + 1) = (sqrt(sum(currentPositions_history(anchor, :, ii + 1) - beliefMean_history(anchor, :, ii + 1)).^2));

            for_abs_error = (currentPositions_history(:, :, ii + 1) - beliefMean_history(:, :, ii + 1)).^2;
            for_abs_error(anchor, :) = 0;
            absError_agent(ii + 1) = (sum(sqrt(sum(for_abs_error, 2)), 1)) / (nVehicles - length(anchor));

            if ii == ii_max
                break
            end

        end
        
        relError_all_avg = sum(relError_all) / ii;
        relError_all_max = max(relError_all);
        relError_all_min = min(relError_all);
        
        relError_anchor_avg = sum(relError_anchor) / ii;
        relError_anchor_max = max(relError_anchor);
        relError_anchor_min = min(relError_anchor(2:ii + 1));
        
        relError_agent_avg = sum(relError_agent) / ii;
        relError_agent_max = max(relError_agent);
        relError_agent_min = min(relError_agent(2:ii + 1));
        
        absError_all_avg = sum(absError_all) / ii;
        absError_all_max = max(absError_all);
        absError_all_min = min(absError_all);
        
        absError_anchor_avg = sum(absError_anchor) / ii;
        absError_anchor_max = max(absError_anchor);
        absError_anchor_min = min(absError_anchor(2:ii + 1));
        
        absError_agent_avg = sum(absError_agent) / ii;
        absError_agent_max = max(absError_agent);
        absError_agent_min = min(absError_agent(2:ii + 1));
        
        allErrors = [absError_all_avg, absError_all_max, absError_all_min, ...
        absError_anchor_avg, absError_anchor_max, absError_anchor_min, ...
        absError_agent_avg, absError_agent_max, absError_agent_min, ...
        relError_all_avg, relError_all_max, relError_all_min, ...
        relError_anchor_avg, relError_anchor_max, relError_anchor_min, ...
        relError_agent_avg, relError_agent_max, relError_agent_min];
        
        allErrors_history(allErrors_history_saveIndex,:) = allErrors;

    end
end

%columns of all saved .mat files: average / max / min
% hist_absError_all = allErrors_history(:, 1:3);
% hist_absError_anchor = allErrors_history(:, 4:6);
% hist_absError_agent = allErrors_history(:, 7:9);
% hist_relError_all = allErrors_history(:, 10:12);
% hist_relError_anchor = allErrors_history(:, 13:15);
% hist_relError_agent = allErrors_history(:, 16:18);
% save('hist_absError_all.mat', 'hist_absError_all')
% save('hist_absError_anchor.mat', 'hist_absError_anchor')
% save('hist_absError_agent.mat', 'hist_absError_agent')
% save('hist_relError_all.mat', 'hist_relError_all')
% save('hist_relError_anchor.mat', 'hist_relError_anchor')
% save('hist_relError_agent.mat', 'hist_relError_agent')

writematrix(allErrors_history, filename);