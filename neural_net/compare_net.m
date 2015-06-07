%test same output for neural net

load('trained_net.mat')

z=36;
k=8;
net_enc=get_encoding_net(net,k,z);
net_dec=get_decoding_net(net,k,z);

% x=randn(64,1);
% x=x/norm(x);

%test with Data
load('Data.mat');
i=randi(size(Data,2))
x=Data(:,i)
