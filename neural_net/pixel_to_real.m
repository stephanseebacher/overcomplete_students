function [ data ] = pixel_to_real ( data )
%PIXEL_TO_REAL Convert pixel values (1..255) to real values (-1..1)
%   and return as a vector
    data = -1 + data * 2/255;
end

