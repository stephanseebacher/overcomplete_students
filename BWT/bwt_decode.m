function decode = bwt_decode( code, index, original_dim )
% Burrows-Wheeler-Transformation decoder
%  code stores the encoded BWT of an image
%  index is indicating the starting point of the original matrix
%  original_dim is the original dimension of the image

% sanity check: if greyscale pic, set third dimension to one
if numel(original_dim) < 3
    original_dim(3) = 1;
end

% sort and store the permutation indexes
[code, idx] = sort(code);

% preallocation
decode = zeros(original_dim);

% for every color channel
for d3 = 1 : original_dim(3)
    for d2 = 1 : original_dim(2)
        for d1 = 1 : original_dim(1)
            % the original matrix entries are stored as permutation
            % in the code, with idx() storing the permutation. starting
            % point is the argument index
            decode(d1, d2, d3) = code(index);
            index = idx(index);
        end
    end
end

end