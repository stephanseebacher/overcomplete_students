function [ net_enc ] = get_encoding_net( net,k,z)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
net_comp=network;
net_comp.numInputs=1;
net_comp.numLayers=1;
net_comp.outputConnect=[1];
net_comp.inputConnect=[1];
net_comp.biasConnect=[1];


%network built, now set weights

%set input size
net_comp.inputs{1}.size=k*k;
%set layers size and implicitly output size (net_comp.outputs{1}.size)
net_comp.layers{1}.size=z;

%set inputs to layers weights 
net_comp.IW{1,1}=net.IW{1,1};

%set same bias
net_comp.b{1,1}=net.b{1,1};

%set same tansig function; basically same parameters as net.layers{1}
net_comp.layers{1}.transferFcn='tansig';
net_comp.layers{1}.initFcn='initnw';
net_enc=net_comp;

end

