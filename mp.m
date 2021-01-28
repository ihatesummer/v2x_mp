rng('default')
system_setting;
allErrors_history = zeros(length(distancesToAnchor) * nRepeat, 18);
save_index = 0;

for distanceToAnchor = distancesToAnchor
    for repeat_index = 1:nRepeat
        save_index = save_index + 1;
        
        % slightly randomize vehicles' y-axis positions
        position(:,2) = position(:,2) + randn(nVehicles, 1); 
        
        get_distances;
        get_aoa;
        initialize_belief;
        initialize_messages;
        
        ii = 1;
        set_history;
        save_history
        evaluate_errors;
        
        while (ii < ii_max)
            ii = ii + 1;
            % cooperative positioning (intervehicular iteration)
            for iter = 1:nIterations
                % factor to variable message update (f_{i,v_j} --> x_{i,n})
                for v_j = 1:nVehicles
                    sum_fij2xin_mean_div_var = [0 0];
                    sum_one_div_fij2xin_var = [0 0];
                    for v_k = 1:nVehicles
                        if v_j ~= v_k && abs(distances_observed(v_j, v_k)) > eps
                            if b_vary_noise_by_AOA
                                variance_theta = variance_theta_crlb(v_j, v_k); %% TODO check variable order (v_j and v_k)
                            end
                            
                            % measurement model message - variance 
                            x = variance_d * cos(aoa_observed(v_j, v_k))^2 + ...
                                distances_observed(v_k, v_j)^2 * variance_theta * sin(aoa_observed(v_k, v_j))^2;
                            y = variance_d * sin(aoa_observed(v_k, v_j))^2 + ...
                                distances_observed(v_k, v_j)^2 * variance_theta * cos(aoa_observed(v_k, v_j))^2;
                            fij2xin_variance(v_k, v_j, :) = xin2fij_variance(v_k, :) + [x y];

                            % measurement model message - mean 
                            fij2xin_mean(v_k, v_j, :) = xin2fij_mean(v_k, :) - distances_observed(v_k, v_j) * ...
                                [cos(aoa_observed(v_k, v_j)) sin(aoa_observed(v_k, v_j))];
                              
                            sum_fij2xin_mean_div_var = sum_fij2xin_mean_div_var + squeeze(fij2xin_mean(v_k, v_j, :) ./ fij2xin_variance(v_k, v_j, :)).';
                            sum_one_div_fij2xin_var = sum_one_div_fij2xin_var + squeeze(1 ./ fij2xin_variance(v_k, v_j, :)).';
                        end %condition_ v_j ~= v_k && abs(distances_observed(v_j,v_k)) > eps
                    end %loop_ v_k = 1:nVehicles
                    
                    % sum-product message update
                    xin2fij_variance(v_j, :) = 1 ./ (1 ./ fi2xin_variance(v_j, :) + sum_one_div_fij2xin_var);
                    xin2fij_mean(v_j, :) = xin2fij_variance(v_j, :) .* ...
                        (fi2xin_mean(v_j, :) ./ fi2xin_variance(v_j, :) + ...
                        sum_fij2xin_mean_div_var);
                    if v_k ~= anchor
                        xin2fij_mean(v_k, :) = position(v_k, :);
                    end
                    
                end %loop_ v_j = 1:nVehicles
            end %loop_ iter = 1:nIterations

            belief_mean = fi2xin_mean;
            belief_variance = fi2xin_variance;
            belief_distances = squareform(pdist(fi2xin_mean));
            get_distances;
            get_aoa;
            save_history;

            error_rel = abs(distances(:, :) - belief_distances(:, : ));
            mean_error_rel_all_history(ii) = mean(error_rel, 'all');
            mean_error_rel_anchor_history(ii) = mean(error_rel(anchor, :), 'all');
            mean_error_rel_agent_history(ii) = mean(error_rel([1:anchor-1 anchor+1:end], :), 'all');
            
            error_abs = sqrt(sum((position_history(:, :, ii) - belief_mean_history(:, :, ii)).^2, 2));
            mean_error_abs_all_history(ii) = mean(error_abs);
            mean_error_abs_anchor_history(ii) = error_abs(anchor);
            mean_error_abs_agent_history(ii) = mean(error_abs([1:anchor-1 anchor+1:end]));

            position = position + avgVelocity * timeInterval;
            
            % mobility message update
            fi2xin_mean = xin2fij_mean + avgVelocity * timeInterval;
            fi2xin_variance = xin2fij_variance + repmat(variation_movement, [nVehicles 1]);
            
        end % ii loop
        allErrors_history(save_index, :) = [get_mean_max_min(mean_error_abs_all_history), get_mean_max_min(mean_error_abs_anchor_history), get_mean_max_min(mean_error_abs_agent_history), get_mean_max_min(mean_error_rel_all_history), get_mean_max_min(mean_error_rel_anchor_history),get_mean_max_min(mean_error_rel_agent_history)];
        
        disp('percentage done:'); disp(save_index / length(allErrors_history) * 100);
        disp(allErrors_history(save_index, :));
    end %nRepeat loop
end % distanceToAnchor loop

writematrix(allErrors_history, strcat(saveLocation, saveFilename));
save(strcat(saveLocation,'workspace'));