function [ data ] = real_to_pixel ( data, k )
%REAL_TO_PIXEL Convert real values (-1..1) to pixel values (-1..1)
%   and return as a k*k matrix
    data = reshape( round( 255/2 + data * 255/2 ), k, k );
end

