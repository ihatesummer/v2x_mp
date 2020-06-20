nRow  = size(data, 1);
nRow_new = nRow / nRepeat;
data_partitioned = reshape(data, nRepeat, nRow_new, []); 
data_processed = sum(data_partitioned, 1) / nRepeat;
data_processed = reshape(data_processed, nRow_new, []);  % Remove leading dim of length 1