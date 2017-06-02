function [selected_max_coefficient,selected_time_indx,selected_channel_indx] = MP(input_signal, maxIter, gammatone_filterbank)
% Implementation of Matching pursuit  signal decomposition on gammatone kernels 
length_signal = length(input_signal);
kernel_length = size(gammatone_filterbank,2);
num_bases = size(gammatone_filterbank,1);
residual = input_signal';
residual = [residual zeros(1,kernel_length+1)];

for iter = 1:maxIter
    iter
    
    for k = 1:num_bases
        projection(k,:) = xcorr(residual(1:length(input_signal)),gammatone_filterbank(k,:));
    end
    % Projection matrix
    projection_matrix = projection(:,length_signal:end);
    [projection_max,indices_max] = max(abs(projection_matrix));

    [selected_max_coefficient(iter), selected_time_indx(iter)] = max(projection_max);
    selected_channel_indx(iter) = indices_max(selected_time_indx(iter));
    selected_max_coefficient(iter) = projection_matrix(selected_channel_indx(iter),selected_time_indx(iter));
    residual(selected_time_indx(iter): selected_time_indx(iter)+kernel_length-1) = residual(selected_time_indx(iter): selected_time_indx(iter)+kernel_length-1)-selected_max_coefficient(iter)*gammatone_filterbank(selected_channel_indx(iter),:);

end

