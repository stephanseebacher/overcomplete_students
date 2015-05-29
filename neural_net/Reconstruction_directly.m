%second test neural net compression
clear all;
close all;

I=imread('1.jpg');
I = double(rgb2gray(I)); 

%compression with nn
% choose kxk chunks unif at random to tran nn
k=8;
[rows,cols]=size(I);

maxrows=floor(rows/k)*k-k;
maxcols=floor(cols/k)*k-k;

Data=[];
training_samples=300;
%create training data
for t=1:training_samples
    i=randi(maxrows);
    j=randi(maxcols);


    %extract kxk chunk
    train_data=I(i:i+k-1,j:j+k-1);
    
    Data=[Data  pixel_to_real( train_data )];
end

% train neural net with z hidden layers z<k*k
z=32;
%create net
setdemorandstream(491218382)
%feedforwardnet very important! patternnet not working for example!
net= feedforwardnet(z);
%target_data is equal to train_data
Target_Data=Data;
[net,tr] = train(net,Data,Target_Data);
nntraintool
%plotperform(tr)
%get widh

%%
I_comp=uint8(zeros(size(I)));
% use trained net to reconstuct each k*k chunk in data

for i=1:k:maxrows
    for j=1:k:maxcols
        %extract kxk chunk
        x=I(i:i+k-1,j:j+k-1);
        %transform kxk chunk to real valued data
        x=pixel_to_real(x);
  
        %use net to compress
        comp_x=net(x);
      
        %transform back real valued data to kxk chunk
        comp_x=real_to_pixel(comp_x,k);
        %set compressed image to computed values
        I_comp(i:i+k-1,j:j+k-1)=uint8(comp_x);
    end
end
% add uncompressed rest of image not handled because of chunk size
I_comp(:,j+k:cols)=I(:,j+k:cols);
I_comp(i+k:rows,:)=I(i+k:rows,:);

subplot(1,2,1),imshow(uint8(I)),title('Original image');
subplot(1,2,2),imshow(I_comp),title('Reconstructed image');
