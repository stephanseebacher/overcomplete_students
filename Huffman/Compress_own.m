function I_comp = Compress_own ( I )
% Huffman-encode an image using MATLAB build-in functions
%  benchmark: I = 20x20 random matrix => 400 elements
%   ~ 0.2 seconds to encode
%   ~ 0.5 seconds to decode

% Huffman works with INT only, but we get double fracts from eval script
I = I*255;
% zeros as symbols are not supported
I(I==0) = 1;

% p is the probability vector over the symbols
p = I(:);
p = accumarray(p, 1);
p = p/numel(I);
[p, idx] = sort(p, 'descend');

% symbols 
symbols = 1:255;
symbols = symbols(idx);

% create huffman codewords
[dict, ~, ~] = Huffman_code(p);

% encode
H = source_coding(I(:), symbols, dict);

I_comp.dim = size(I);
I_comp.H = H;
I_comp.dict = dict;
I_comp.symbols = symbols;
end
