function [ ] = neural_net_training ( k, training_samples, z )
% NEURAL_NET_TRAINING Initial neural net training function
%   k = patch size
%   z = amount of hidden layers in the neural network

% time it!
%ttrain = tic;

%% SETTINGS + PARAMETERS --------------------------------------------------
% where are the pictures?
picutres_dir = 'Training_Set';
trained_net = ['trained_net_k_' num2str(k) '_z_' num2str(z) '.mat'];

% choose training_samples kxk chunks uniform at random to trian the nn
% k = 8;
% training_samples = 100;

% train neural net with z hidden layers z<k*k, better be power of 2 to show
% compressed image afterwards
% z = 32;

%setdemorandstream(491218382) %used to avoid randomness, and get similar results after each training
%feedforwardnet very important! patternnet not working for example!
net = feedforwardnet( z );

% Training paramters
%  set particular training goal
%  TODO: choose carefully
net.trainParam.goal = 0.00001;
% max iterations
net.trainParam.epochs = 10000;
% max training time in seconds
net.trainParam.time = 1800;
% set training function
%net.trainFcn = 'trainlm'; % so far default used because faster
% before 'trainlm' used but problem with memory management!
net.trainFcn = 'trainoss';

%% TRAINING ---------------------------------------------------------------

% first create training data
direc = dir( picutres_dir );

% get all images names
images_names = { direc.name };

% extract training data patches from image
Data = [];
for i = 3 : size( images_names, 2 )
    current_image = double( imread( [ picutres_dir '/' images_names{ i }]));
    Data = [Data get_training_data( current_image, k, training_samples )]; %#ok<AGROW>
end

Target_Data = Data;

% train
disp('Training...')
[net, ~] = train( net, Data, Target_Data );
%nntraintool

% choose configuration data randomly
i = randi( size( Data, 2 ));
net_enc = get_encoding_net( net, k, z, Data( :, i )); %#ok<NASGU>

% send decoding net data
net_dec_LW = net.LW{ 2, 1 };
net_dec_b = net.b{ 2, 1 };
% choose configuration data randomly
j = randi( size( Target_Data, 2 ));
net_dec_configure_data = Target_Data( :, j );
net_dec = { net_dec_LW, net_dec_b, net_dec_configure_data }; %#ok<NASGU>
%net_dec = get_decoding_net( net, k, z ); %#ok<NASGU>

% save the net at the end
save( trained_net, 'net_enc', 'net_dec' );
%disp(['Training done in ' num2str( toc( ttrain )) ' seconds'])

end % neural_net_training
