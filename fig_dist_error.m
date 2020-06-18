set(gcf,'Color','w');
ii=1000;

data = load('error_abs.txt');
data = data(1:1000,2:1001);
all_abs_mean = mean(data,1);
p1 = plot(2*(1:ii), all_abs_mean,'-+','Color','r','LineWidth',2.5);
p1.MarkerIndices = 1:100:length(all_abs_mean);

hold on

data2 = load('error_rel.txt');
data2 = data2(1:1000,2:1001);
all_rel_mean = mean(data2);
p2 = plot(2*(1:ii), all_rel_mean, '-+', 'Color', '[1 0.6 0.6]', 'LineWidth',2.5);
p2.MarkerIndices = 1:100:length(all_abs_mean);

hold on

data3 = load('error_abs_noAnchor.txt');
data3 = data3(1:1000,2:1001);
no_anchor_abs_mean = mean(data3);
p3=plot(2*(1:ii),no_anchor_abs_mean,'-s','Color','b','LineWidth',2.5);
p3.MarkerIndices = 1:100:length(no_anchor_abs_mean);

hold on

data4 = load('error_rel_noAnchor.txt');
data4 = data4(1:1000,2:1001);
no_anchor_rel_mean = mean(data4);
p4=plot(2*(1:ii),no_anchor_rel_mean,'-s','Color','[0.6 0.6 1]','LineWidth',2.5);
p4.MarkerIndices = 1:100:length(no_anchor_rel_mean);

axis([0 2000 0 12])
legend('Absolute','Relative','Absolute, no anchor','Relative, no anchor')
xlabel('dist (m)', 'FontSize', 10)
ylabel('error (m)', 'FontSize', 10)
grid on
%legend('location','northwest')

saveas(gcf,'fig_dist_error','fig')