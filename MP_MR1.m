function [selected_max_coefficient,selected_time_indx,selected_channel_indx] = MP_MR1(input_signal, maxIter, gammatone_filterbank, no_segments)
% Localized matching pursui using gammatone kernels:  the signal is divided into short frames. The residual signal at each iteration
%is  computed by reducing the contribution of kernels found in all frames 
% % Yousof Erfani, Mcmaster University:erfaniy@mcmaster.ca

%Initialization
length_signal = length(input_signal);
kernel_length = size(gammatone_filterbank, 2);
num_bases = size(gammatone_filterbank, 1);
residual = input_signal';
cnt = 1;
residual = [residual zeros(1, kernel_length+1)];


for iter = 1:maxIter
    iter
    
    for k = 1:num_bases
         projection(k,:) = xcorr(residual(1:length(input_signal)), gammatone_filterbank(k,:));
    end
    

    projection_matrix = projection(:, length_signal:end);

    [projection_max,indices_max] = max(abs(projection_matrix));
    processing_window = floor( length(projection_max) / no_segments );

    
    for iter2 = 1: 1: no_segments
        [selected_max_coefficient(cnt), selected_time_indx(cnt)] = max(projection_max(1+(iter2-1)*processing_window:iter2*processing_window));
        selected_time_indx(cnt) = selected_time_indx(cnt)+(iter2-1)*processing_window;

        selected_channel_indx(cnt) = indices_max(selected_time_indx(cnt));
        selected_max_coefficient(cnt) = projection_matrix(selected_channel_indx(cnt),selected_time_indx(cnt));

        residual(selected_time_indx(cnt): selected_time_indx(cnt)+kernel_length-1) = residual(selected_time_indx(cnt): selected_time_indx(cnt)+ kernel_length-1)-selected_max_coefficient(cnt)*gammatone_filterbank(selected_channel_indx(cnt),:);
        cnt = cnt + 1
    end
    

end

