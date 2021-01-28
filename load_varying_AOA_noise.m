crlb = circshift(crlb,900); % To assume given 0 degree is w.r.t y-axis. If not, comment this off.

% original .mat data range: -90deg ~ 90deg, with 0.01deg interval
% Assuming symmetry, extend the range to -90deg ~ 270deg
crlb = [crlb; crlb]; 
variance_theta = (pi ./ 180 .* crlb) .^ 2;
clearvars('crlb')