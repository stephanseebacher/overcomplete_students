function [ I_comp ] = Compress( I )
% Compression with neural networks

%timeit = tic;

%% SETTINGS + PARAMETERS --------------------------------------------------
% choose training_samples k*k chunks uniform at random to train the NN
patch_size = 8;

training_samples = 100;

% train neural net with z hidden layers z<k*k, better be power of 2 to show
%   compressed image afterwards
hidden_layers = 4;

% use for quantization
q_bits = 4;

%% PREPROCESS -------------------------------------------------------------

% images fixes include row and column padding and converting the values
%   to pixel values (1..255)
If = fix_image( I, patch_size );

%% TRAINING ---------------------------------------------------------------

% use trained net instead of new one!
trained_net = ['trained_net_k_' num2str( patch_size ) '_z_' num2str( hidden_layers ) '.mat'];
if ~exist( trained_net, 'file' )
    neural_net_training( patch_size, training_samples, hidden_layers );
end

load( trained_net );
display('Trained net loaded and ready for further optimization.')

%% ENCODING ---------------------------------------------------------------
% now encode the image

% extract patches
Ir = pixel_to_real( extract_patches( If, patch_size ));

q_size1 = ceil( hidden_layers * q_bits  / 8 );
Iq = int8( zeros( q_size1, size( Ir, 2 )));

% convert every patch to real, encode and quantize it
Ie = net_enc( Ir );

% quantize the result
for i = 1 : size( Ie, 2)
    Iq( :, i ) = quantize( Ie( :, i ), q_bits );
end

% send compressed data matrix
I_comp.compressed_data = Iq;

%send decoding net data
%I_comp.net_dec_data = { net_dec_LW, net_dec_b, net_dec_configure_data };
I_comp.net_dec = net_dec;

%add image propererties
%I_comp.image_size = { rows, cols, colours, maxrows, maxcols };
I_comp.image_size = size( I );

% add properties
I_comp.patch_size = patch_size;
I_comp.hidden_layers = hidden_layers;
I_comp.q_bits = q_bits;
%I_comp.comp_properties = { patch_size, hidden_layers, q_bits };

%disp(['Compression time: ' num2str( toc( timeit ))])

end % Compress
