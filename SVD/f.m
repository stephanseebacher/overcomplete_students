function [ fill_rows, fill_cols ] = f( s, p )
%F Summary of this function goes here
%   Detailed explanation goes here

% number of rows and columns to add in pre-processing step
fill_rows = p * ceil(s(1) / p) - s(1);
fill_cols = p * ceil(s(2) / p) - s(2);

end

