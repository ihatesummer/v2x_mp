index_absError_all_avg = 1;
index_relError_all_avg = 10;
labels = {...
    'Fixed variance', ...
    'CRLB, N41', ...
    'CRLB, N21', ...
    'CRLB, N11', ...
    'CRLB, N9', ...
    'CRLB, N7', ...
    'CRLB, N5'};
files = {...
    'hist_all_variance_fixed.csv', ...
    'hist_all_variance_crlb_N41.csv', ...
    'hist_all_variance_crlb_N21.csv', ...
    'hist_all_variance_crlb_N11.csv', ...
    'hist_all_variance_crlb_N9.csv', ...
    'hist_all_variance_crlb_N7.csv', ...
    'hist_all_variance_crlb_N5.csv' ...
    };

%%
abs = figure;

for i = 1:length(files)
    data = load(files{i});
    data_preprocess;
    plot(distancesToAnchor, data_processed(:, index_absError_all_avg), '-o', 'LineWidth', 1.5);
    hold on;
end

legend(labels, 'Location', 'southeast');
xlabel('y-axis distance to anchor [m]', 'FontSize', 10);
ylabel('Absolute error [m]', 'FontSize', 10);
grid on

saveas(abs, 'abs')

%%
rel = figure;

for i = 1:length(files)
    data = load(files{i});
    data_preprocess;
    plot(distancesToAnchor, data_processed(:, index_relError_all_avg), '-o', 'LineWidth', 1.5);
    hold on;
end

legend(labels, 'Location', 'southeast');
xlabel('y-axis distance to anchor [m]', 'FontSize', 10);
ylabel('Relative error [m]', 'FontSize', 10);
grid on

saveas(rel, 'rel')
