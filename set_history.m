%%
% initialize histories (pre-allocate spaces)
position_history = zeros([size(position), ii_max]);
distances_history = zeros([size(distances), ii_max]);
distances_observed_history = zeros([size(distances_observed), ii_max]);
aoa_history = zeros([size(aoa), ii_max]);
aoa_observed_history = zeros([size(aoa_observed), ii_max]);
belief_mean_history = zeros([size(belief_mean), ii_max]);
belief_distances_history = zeros([size(belief_distances), ii_max]);
belief_variance_history = zeros([size(belief_variance), ii_max]);

mean_error_rel_all_history = zeros(1, ii_max);
mean_error_rel_anchor_history = zeros(1, ii_max);
mean_error_rel_agent_history = zeros(1, ii_max);
mean_error_abs_all_history = zeros(1, ii_max);
mean_error_abs_anchor_history = zeros(1, ii_max);
mean_error_abs_agent_history = zeros(1, ii_max);
