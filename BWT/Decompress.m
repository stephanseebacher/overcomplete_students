function I_rec = Decompress ( I_comp )
% decode BWT transformed image

for i = 1 : size(X, 2)
    X(:, i) =  bwt_decode(X(:, i), I_comp.idx(i), size(X(:, i)));
end

I_rec = reassemble(X, I_comp.dim);

end