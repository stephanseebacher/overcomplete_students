function I_comp = Compress(I)

[rows,cols,colours]=size(I);
%train on gray scale image if image is colored
if (colours > 1) 
    I_gray = double(rgb2gray(I)); 
else
    I_gray=double(I);
end
I=double(I);
%compression with neural net
% choose training_samples kxk chunks unif at random to trian the nn
k=8;


maxrows=floor(rows/k)*k-k;
maxcols=floor(cols/k)*k-k;

Data=[];
training_samples=300;
%create training data
for t=1:training_samples
    i=randi(maxrows);
    j=randi(maxcols);


    %extract kxk chunk
    train_data=I_gray(i:i+k-1,j:j+k-1);
    
    %add to train data
    Data=[Data  pixel_to_real( train_data )];
end

% train neural net with z hidden layers z<k*k, better be power of 2 to show
% compressed image afterwards
z=36;
%create net
setdemorandstream(491218382)
%feedforwardnet very important! patternnet not working for example!
net= feedforwardnet(z);
%target_data is equal to train_data
Target_Data=Data;

% Training paramters
%set particular training goal 
%TODO: choose carefully
net.trainParam.goal=0.01;
%max iterations
net.trainParam.epochs=4;
%max training time in seconds
net.trainParam.time=20; 

% set trainging function
% net.trainFcn ='trainlm'; % so far default used because faster

[net,tr] = train(net,Data,Target_Data);
nntraintool

net_enc=get_encoding_net(net,k,z);
net_dec=get_decoding_net(net,k,z);

%now encode all the image
I_compressed=int16(zeros(maxrows/k*sqrt(z),maxcols/k*sqrt(z),colours)); % to correct/make sure
% use trained net to reconstuct each k*k chunk in data
for c=1:colours
    i_c=1;
    for i=1:k:maxrows
        j_c=1;
        for j=1:k:maxcols
            %extract kxk chunk
            x=I(i:i+k-1,j:j+k-1,c);
            %transform kxk chunk to real valued data
            x=pixel_to_real(x);

            %use net to compress
            comp_x=net_enc(x);
            
            %quanitize data for compression to 
            
            %reshape data
            comp_x=reshape(comp_x,sqrt(z),sqrt(z));
            %set compressed image to computed values
            I_compressed(i_c:i_c+sqrt(z)-1,j_c:j_c+sqrt(z)-1,c)=int16(comp_x*10000);
            j_c=j_c+sqrt(z);
        end
        i_c=i_c+sqrt(z);
    end
end
figure;
subplot(1,2,1),imshow(uint8(I)),title('Original image');
subplot(1,2,2),imshow(uint8(I_compressed)),title('Compressed image');


I_comp.I = I_compressed;
I_comp.net_dec = net_dec;
% add uncompressed rest of image not handled because of chunk size, to add
% for reconstuction
I_comp.uncompressed_part={I(:,j+k:cols,:), I(i+k:rows,:,:)};
%add size image
I_comp.image_size={rows,cols,colours,k,z,maxrows,maxcols};