function [ train_data ] = real_to_pixel( train_data,k)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    %convert real to pixel values
    for i=1:length(train_data)
        train_data(i)=255/2+train_data(i)*(255/2);
    end
    %convet back to chunk
    train_data=reshape(train_data,k,k);
end

