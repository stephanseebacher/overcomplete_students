function [ net_dec ] = get_decoding_net(net,k,z,data_configure)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

net_dec=network;

net_dec.numInputs=1;
net_dec.numLayers=1;
net_dec.outputConnect=[1];
net_dec.inputConnect=[1];
net_dec.biasConnect=[1];

%configure output processing
net_dec=configure(net_dec,'outputs',data_configure);
net_dec.outputs{1}.processFcns={'mapminmax'};

%network built, now set weights

%set input size
net_dec.inputs{1}.size=z;
%set layers size and implicitly output size (net_dec.outputs{1}.size)
net_dec.layers{1}.size=k*k;

%set inputs weighs to layers weights 
net_dec.IW{1,1}=net.LW{2,1};

%set same bias
net_dec.b{1,1}=net.b{2,1};

%set same tansig function; basically same parameters as net.layers{1}
net_dec.layers{1}.transferFcn='purelin';
net_dec.layers{1}.initFcn='initnw';

end

