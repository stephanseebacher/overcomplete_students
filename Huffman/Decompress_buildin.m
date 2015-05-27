function I_rec = Decompress_buildin ( I_comp )
% Huffman decode

I_rec = reshape(huffmandeco(I_comp.H, I_comp.dict), I_comp.dim);
end