function I_rec = Decompress ( I_comp )

% Your decompression code goes here!
X = I_comp.U * diag(I_comp.S) * I_comp.V';

I_rec = reassemble(X, I_comp.size);

%I_rec = I_comp.I; % this is just a stump to make the evaluation script run, replace it with your code!
end