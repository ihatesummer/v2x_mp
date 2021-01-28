distances = squareform(pdist(position));

distances_observed = distances + sqrt(variance_d) * randn(size(distances)); %z_ijn
distances_observed(1:1 + size(distances, 1):end) = 0; %eliminating diagonal entries