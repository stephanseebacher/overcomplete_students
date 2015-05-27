function I_rec = Decompress_own ( I_comp )
% Huffman decode

I_rec = reshape(source_decoding(I_comp.H, I_comp.dict, I_comp.symbols), I_comp.dim);
end