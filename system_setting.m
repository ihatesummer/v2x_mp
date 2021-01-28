b_vary_noise_by_AOA = false;

variance_d = 1; % meters
if b_vary_noise_by_AOA
    load_varying_AOA_noise;
else
    variance_theta = (pi / 180 * 3)^2; % radians
end

nVehicles = 10;
nIterations = 10;
nLanes = 5;
anchor = round(nVehicles / 2); % anchor in the middle lane

variation_movement = [0.1, 1.0]; % x and y directions
timeInterval = 0.1;

avgVelocity_x = 0; % m/s
avgVelocity_y = 36; % 36 m/s = 129.6 km/h
avgVelocity_y_anchor = 36; % 36 m/s = 129.6 km/h
avgVelocity = [ones(nVehicles,1)*avgVelocity_x, ones(nVehicles,1) * avgVelocity_y];
avgVelocity(anchor,2) = avgVelocity_y_anchor;
clearvars('avgVelocity_x', 'avgVelocity_y', 'avgVelocity_y_anchor');

distancesToAnchor = 0:1:5; % meters

nRepeat = 5;
ii_max = 20; % TODO findout what this exactly is, then rename this.

lane_width = 3.5; % meters
position_x = [1;1]*(1:5) * lane_width;
position_x = position_x(:);
position_y = zeros(nVehicles, 1);
position = [position_x position_y];
clearvars('position_x', 'position_y', 'lane_width')
