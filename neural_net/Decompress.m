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

% temp matrix for dequantized values
inflate = zeros( hidden_layers, size( comp, 2 ));

for i = 1 : size( comp, 2 )
    inflate( :, i ) = extract_compr( comp( :, i ), number_bits_encoded, q_bits);
end

% apply decoding net, then convert from real values to pixel values
Id = real_to_pixel( net_dec( inflate ));

% convert patch vectors into image chunks and put them into matrix
I_rec = reassemble_patches( Id, I_comp.image_size );

% in fix_image function, we multiplied by 255
I_rec = I_rec / 255;

%disp(['Decompression time: ' num2str( toc( timeit ))])

end % Decompress