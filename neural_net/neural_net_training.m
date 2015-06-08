% initial Neural Net Training

%first create training data

%timing for everything
ttrain=tic;

file_name='Training_Set';
direc=dir(file_name);

% get all images names
images_names={direc.name};

% choose  chunks size
k=6;
% train neural net with z hidden layers z<k*k, better be power of 2 to show
% compressed image afterwards
z=4;

%number of training samples per image
training_samples=100;

Data=[];
for i=3:size(images_names,2)
    
    current_image=double(imread([ file_name '/' images_names{i}]));
    
    [rows,cols,colours]=size(current_image);
    
    %train on gray scale image if image is colored
    if (colours > 1) 
        I_gray = double(rgb2gray(uint8(current_image))); 
    else
        I_gray=current_image;
    end
    
 

    maxrows=floor(rows/k)*k-k;
    maxcols=floor(cols/k)*k-k;

    %create training data
    for t=1:training_samples
        
        % choose training_samples kxk chunks size unif at random to trian the nn
        i=randi(maxrows);
        j=randi(maxcols);


        %extract kxk chunk
        train_data=I_gray(i:i+k-1,j:j+k-1);

        %add to train data
        Data=[Data  pixel_to_real( train_data )];
    end

    
end

%%


%create net
% setdemorandstream(491218382) %used to avoid slightly diff results every time it is run
%feedforwardnet very important! patternnet not working for example!
net= feedforwardnet(z);
%target_data is equal to train_data
Target_Data=Data;

% set trainging function
% befaure 'trainlm' used but problem with memory managment!
net.trainFcn ='trainoss'; % so far default used because faster

% Training paramters
%set particular training goal 
%TODO: choose carefully
net.trainParam.goal=0.00001;
%max iterations
net.trainParam.epochs=10000;
%max training time in seconds
net.trainParam.time=1800; 



[net,tr] = train(net,Data,Target_Data);
nntraintool

%save the net at the end
save(['trained_net_k_' num2str(k) '_z_' num2str(z) '.mat'], 'net');
disp(['Training done in ' num2str(toc(ttrain))])
