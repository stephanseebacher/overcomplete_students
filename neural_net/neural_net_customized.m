load('net_saved.mat');
view(net)
%compression/encoding net

net_comp=network;
net_comp.numInputs=1;
net_comp.numLayers=1
net_comp.outputConnect=[1];
net_comp.inputConnect=[1];
net_comp.biasConnect=[1];


%network built, now set weights

%set input size
net_comp.inputs{1}.size=64
%set layers size and implicitly output size (net_comp.outputs{1}.size)
net_comp.layers{1}.size=32

%set inputs to layers weights 
net_comp.IW{1,1}=net.IW{1,1}

%set same bias
net_comp.b{1,1}=net.b{1,1};

%set same tansig function; basically same parameters as net.layers{1}
net_comp.layers{1}.transferFcn='tansig';
net_comp.layers{1}.initFcn='initnw';

view(net_comp);

% decoding net

net_dec=network;
net_dec.numInputs=1;
net_dec.numLayers=1
net_dec.outputConnect=[1];
net_dec.inputConnect=[1];
net_dec.biasConnect=[1];


%network built, now set weights

%set input size
net_dec.inputs{1}.size=32
%set layers size and implicitly output size (net_dec.outputs{1}.size)
net_dec.layers{1}.size=64

%set inputs weighs to layers weights 
net_dec.IW{1,1}=net.LW{2,1};

%set same bias
net_dec.b{1,1}=net.b{2,1};

%set same tansig function; basically same parameters as net.layers{1}
net_dec.layers{1}.transferFcn='purelin';
net_dec.layers{1}.initFcn='initnw';

view(net_dec);