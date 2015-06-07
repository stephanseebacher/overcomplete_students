function [ train_data ] = pixel_to_real( train_data )
%convert train_data sub image with values between 0 and 255 into vector of real values between -1 and 1.
    
    %vectorized it
    train_data=train_data(:);
    train_data=train_data*(2/255)- ones(length(train_data),1);

end

