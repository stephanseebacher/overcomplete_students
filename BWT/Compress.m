function I_comp = Compress(I)
% BWT on patches 
%  This is not a compression per se, but could be used as a preparation 
%  step for another compression algorithm.

% get patches
X = extract(I,d);

% do the Burrows-Wheeler transformation on every patch
for i = 1 : size(X, 2)
    [X(:, i), idx(i)] = bwt_encode(X(:, i));
end

% return struct
I_comp.X = X;
I_comp.idx = idx;
end
