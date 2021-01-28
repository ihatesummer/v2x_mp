%%coorinateDifferences(v1,v2,<1 or 2> for <x or y> axis)
coorinateDifferences = repmat(permute(position, [1 3 2]), [1 nVehicles]) - ...
    repmat(permute(position, [3 1 2]), [nVehicles 1]);

aoa = atan(coorinateDifferences(:, :, 2) ./ coorinateDifferences(:, :, 1));

% atan's range: -pi~pi
% to receive appropriate cos(aoa), add pi if x-axis difference < 0
aoa = aoa + (coorinateDifferences(:, :, 1) < 0) * pi; 

% indexing: aoa(to(v_k), from(v_j), :)

%eliminating diagonal entries
aoa(1:1 + size(aoa, 1):end) = 0;

if b_vary_noise_by_AOA
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