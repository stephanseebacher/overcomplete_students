function [ I ] = fix_image( I, d )
% FIX_IMAGE Image adapdations
%   Row and column padding
%   Convert values to pixel values (1..255)

I = I * 255;

% number of rows and columns to add 
fill_rows = d * ceil( size( I, 1 ) / d ) - size( I, 1 );
fill_cols = d * ceil( size( I, 2 ) / d ) - size( I, 2 );

% fills matrix with rows and columns to that
% patch size divides evenly
if fill_rows ~= 0
    I = [I; repmat( I( size( I, 1 ), :, : ), [fill_rows 1])];
end

if fill_cols ~= 0
    I = [I repmat( I( :, size( I, 2 ), :), [1 fill_cols])];
end

end
