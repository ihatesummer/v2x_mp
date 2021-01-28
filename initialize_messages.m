% mobility model initialization
fi2xin_mean = belief_mean;
fi2xin_variance = belief_variance + repmat(variation_movement, [nVehicles 1]);
% sum-product initialization
xin2fij_mean = fi2xin_mean;
xin2fij_variance = fi2xin_variance;
% measurement model initialization
fij2xin_mean = zeros([size(distances_observed), 2]);
fij2xin_variance = zeros([size(distances_observed), 2]);