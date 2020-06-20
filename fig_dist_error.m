index_absError_all_avg = 1;
index_relError_all_avg = 10;

%%
abs = figure;

data = load('hist_all_variance_fixed.csv');
data_preprocess;
fig_abs_fixedVar = plot(distanceToAnchor, data_processed(:,index_absError_all_avg),'-o','LineWidth',1.5);
hold on;

data = load('hist_all_variance_crlb_N41.csv');
data_preprocess;
fig_abs_crlbVar_N41 = plot(distanceToAnchor, data_processed(:,index_absError_all_avg),'-o','LineWidth',1.5);
hold on;

data = load('hist_all_variance_crlb_N21.csv');
data_preprocess;
fig_abs_crlbVar_N21 = plot(distanceToAnchor, data_processed(:,index_absError_all_avg),'-o','LineWidth',1.5);
hold on;

data = load('hist_all_variance_crlb_N11.csv');
data_preprocess;
fig_abs_crlbVar_N11 = plot(distanceToAnchor, data_processed(:,index_absError_all_avg),'-o','LineWidth',1.5);
hold on;

data = load('hist_all_variance_crlb_N9.csv');
data_preprocess;
fig_abs_crlbVar_N9 = plot(distanceToAnchor, data_processed(:,index_absError_all_avg),'-o','LineWidth',1.5);
hold on;

% data = load('hist_all_variance_crlb_N7.csv');
% data_preprocess;
% fig_abs_crlbVar_N7 = plot(distanceToAnchor, data_processed(:,index_absError_all_avg),'-o','LineWidth',1.5);
% hold on;

data = load('hist_all_variance_crlb_N5.csv');
data_preprocess;
fig_abs_crlbVar_N5 = plot(distanceToAnchor, data_processed(:,index_absError_all_avg),'-o','LineWidth',1.5);

legend('Fixed variance','CRLB, N41','CRLB, N21','CRLB, N11', 'CRLB, N9', 'CRLB, N5', 'Location', 'southeast');
xlabel('y-axis distance to anchor [m]', 'FontSize', 10);
ylabel('Absolute error [m]', 'FontSize', 10);
grid on

saveas(abs,'abs')

%%
rel = figure;

data = load('hist_all_variance_fixed.csv');
data_preprocess;
fig_abs_fixedVar = plot(distanceToAnchor, data_processed(:,index_relError_all_avg),'-o','LineWidth',1.5);
hold on;

data = load('hist_all_variance_crlb_N41.csv');
data_preprocess;
fig_abs_crlbVar_N41 = plot(distanceToAnchor, data_processed(:,index_relError_all_avg),'-o','LineWidth',1.5);
hold on;

data = load('hist_all_variance_crlb_N21.csv');
data_preprocess;
fig_abs_crlbVar_N21 = plot(distanceToAnchor, data_processed(:,index_relError_all_avg),'-o','LineWidth',1.5);
hold on;

data = load('hist_all_variance_crlb_N11.csv');
data_preprocess;
fig_abs_crlbVar_N11 = plot(distanceToAnchor, data_processed(:,index_relError_all_avg),'-o','LineWidth',1.5);
hold on;

data = load('hist_all_variance_crlb_N9.csv');
data_preprocess;
fig_abs_crlbVar_N9 = plot(distanceToAnchor, data_processed(:,index_relError_all_avg),'-o','LineWidth',1.5);
hold on;

% data = load('hist_all_variance_crlb_N7.csv');
% data_preprocess;
% fig_abs_crlbVar_N7 = plot(distanceToAnchor, data_processed(:,index_relError_all_avg),'-o','LineWidth',1.5);
% hold on;

data = load('hist_all_variance_crlb_N5.csv');
data_preprocess;
fig_abs_crlbVar_N5 = plot(distanceToAnchor, data_processed(:,index_relError_all_avg),'-o','LineWidth',1.5);

legend('Fixed variance','CRLB, N41','CRLB, N21','CRLB, N11', 'CRLB, N9','CRLB, N5', 'Location', 'southeast');
xlabel('y-axis distance to anchor [m]', 'FontSize', 10);
ylabel('Relative error [m]', 'FontSize', 10);
grid on

saveas(rel,'rel')


