% runtime of mp.m: about 160.674544 seconds
% runtime of this script: 160.674544 seconds * 7 = about 18.7454 minutes

crlb_loaded = false;
filename = 'hist_all_variance_fixed.csv';
mp

crlb_loaded = true;
load('aoa_crlb_data/CRLB_data_N41.mat')
filename = 'hist_all_variance_crlb_N41.csv';
mp
load('aoa_crlb_data/CRLB_data_N21.mat')
filename = 'hist_all_variance_crlb_N21.csv';
mp
load('aoa_crlb_data/CRLB_data_N11.mat')
filename = 'hist_all_variance_crlb_N11.csv';
mp
load('aoa_crlb_data/CRLB_data_N9.mat')
filename = 'hist_all_variance_crlb_N9.csv';
mp
load('aoa_crlb_data/CRLB_data_N7.mat')
filename = 'hist_all_variance_crlb_N7.csv';
mp
load('aoa_crlb_data/CRLB_data_N5.mat')
filename = 'hist_all_variance_crlb_N5.csv';
mp