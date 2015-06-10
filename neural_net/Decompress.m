function [ I_rec ] = Decompress( I_comp )

%timeit = tic;

%% INIT -------------------------------------------------------------------
%read data for recontruction
comp                = I_comp.compressed_data;
patch_size          = I_comp.patch_size;
hidden_layers       = I_comp.hidden_layers;
q_bits              = I_comp.q_bits;

number_bits_encoded = hidden_layers * q_bits;

% get decoding net data
net_dec_data        = I_comp.net_dec;
net_dec             = get_decoding_net_2( ...
                        net_dec_data{ 1 }, ...
                        net_dec_data{ 2 }, ...
                        patch_size, hidden_layers, ...
                        net_dec_data{ 3 });

%% RECONSTRUCT & DECOMPRESS -----------------------------------------------

Id = zeros( patch_size^2, size( comp, 2 ));

for i = 1 : size( comp, 2 )
    inflate = extract_compr( comp( :, i ), number_bits_encoded, q_bits);
    Id( :, i ) = real_to_pixel( net_dec( inflate ));
end


I_rec = reassemble_patches( Id, I_comp.image_size );
I_rec = I_rec / 255;

%disp(['Decompression time: ' num2str( toc( timeit ))])

end % Decompress