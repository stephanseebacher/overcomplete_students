function [ train_data ] = pixel_to_real( train_data )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    
    %vectorized it
    train_data=train_data(:);
    %convert pixel to real values between -1 and 1
    for i=1:length(train_data)
        train_data(i)=-1+train_data(i)*(2/255);
    end

end

