function I_comp = Compress_buildin ( I )
% Huffman-encode an image using MATLAB build-in functions
%  benchmark: I = 20x20 random matrix => 400 elements
%   ~ 0.7 seconds to encode
%   ~ 1.1 seconds to decode

% Huffman works with INT only, but we get double fracts
I = I*255;
% zeros as symbols are not supported
I(I==0) = 1;

% Huffman dict
% p is the probability vector
p = I(:);
p = accumarray(p, 1);
p = p/numel(I);
%[p, idx] = sort(p, 'descend');

symbols = 1:255;
%symbols = symbols(idx);

[dict, ~] = huffmandict(symbols, p);

H = huffmanenco(I(:), dict);

I_comp.dim = size(I);
I_comp.H = H;
I_comp.dict = dict;
end
