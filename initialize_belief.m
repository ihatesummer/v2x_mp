%Gaussian approximation
%initial message parameter definition (initial belief)
belief_mean = position + sqrt(variance_d) * randn(size(position)) / 2;

x = squareform(pdist(belief_mean(:, 1)));
y = squareform(pdist(belief_mean(:, 2)));
belief_distances = sqrt(x.^2 + y.^2);

belief_variance = variance_d * ones(size(position));
clearvars('x', 'y');