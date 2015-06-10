function [ data ] = get_training_data ( I, k, training_samples )
% GET_TRAINING_DATA Extracts random chunks of picture
%   I = image (double, matrix)
%   s = chunk size
%   training_samples = number of chunks to be extracted

[rows, cols, color] = size( I );

maxrows = floor( rows / k ) * k - k;
maxcols = floor( cols / k ) * k - k;

% train on gray scale image if image is colored
if color > 1
    I = double( rgb2gray( uint8( I ))); 
end

data = zeros( k * k, training_samples );

for t = 1 : training_samples
    i = randi( maxrows );
    j = randi( maxcols );

    %extract kxk chunk
    train_data = I( i : i+k-1, j : j+k-1 );
    
    % add to train data
    data( :, t )= pixel_to_real( train_data );
end

end
