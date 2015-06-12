function [ data ] = real_to_pixel ( data )
%REAL_TO_PIXEL Convert real values (-1..1) to pixel values (-1..1)
    data = round( 255/2 + data * 255/2 );
end

