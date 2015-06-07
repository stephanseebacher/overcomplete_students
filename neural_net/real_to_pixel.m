function [ train_data ] = real_to_pixel( train_data,k)
% Convert vector of real values between -1 and 1 to sub_image patch with
% pixel values between 1 and 255

    %convert real to pixel values
    train_data=ones(length(train_data),1)*255/2 + train_data*(255/2);
    %convet back to chunk
    train_data=reshape(train_data,k,k);
end

