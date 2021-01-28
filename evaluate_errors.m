relDiff = distances_history(:, :, ii) - belief_distances_history(:, :, ii);
absDiff = position_history(:, :, ii) - belief_mean_history(:, :, ii);
absDiff_L2 = sqrt(sum(absDiff.^2, 2)); %L2 norm

error_rel_all = mean(abs(relDiff), 'all');
error_abs_all = mean(absDiff_L2);

error_rel_all_history(ii) = error_rel_all;
error_abs_all_history(ii) = error_abs_all;

clearvars('relDiff', 'absDiff', 'absDiff_L2','error_rel_all','error_abs_all');