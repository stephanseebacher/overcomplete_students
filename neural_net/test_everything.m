close all;
clear all;
I=imread('1.jpg');

%train on gray scale image
I_gray = double(rgb2gray(I)); 
I=double(I);

%compression with neural net
% choose training_samples kxk chunks unif at random to trian the nn
k=8;
[rows,cols,colours]=size(I);

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
[net,tr] = train(net,Data,Target_Data);
nntraintool

net_enc=get_encoding_net(net,k,z);
net_dec=get_decoding_net(net,k,z);

%%
%now encode all the image

I_compressed=double(zeros(maxrows/k*sqrt(z),maxcols/k*sqrt(z),3)); % to correct
% use trained net to reconstuct each k*k chunk in data
for c=1:3
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

    %         %transform back real valued data to sqrt(z) x sqrt(z) chunk and
    %         %quantisize data: so compress even more!
    %         comp_x=real_to_pixel(comp_x,sqrt(z));

            %reshape data
            comp_x=reshape(comp_x,sqrt(z),sqrt(z));
            %set compressed image to computed values
            I_compressed(i_c:i_c+sqrt(z)-1,j_c:j_c+sqrt(z)-1,c)=comp_x;
            j_c=j_c+sqrt(z);
        end
        i_c=i_c+sqrt(z);
    end
end
% add uncompressed rest of image not handled because of chunk size, to add
% for reconstuction
subplot(1,2,1),imshow(uint8(I)),title('Original image');
subplot(1,2,2),imshow(I_compressed),title('Compressed image');

%%

I_reconstructed=zeros(rows,cols,3); % to correct
% use trained net to reconstuct each k*k chunk in data
for c=1:3
    i_c=1;
    for i=1:k:maxrows
        j_c=1;
        for j=1:k:maxcols
            %extract squrt(z)x sqrt(z) chunk
            x=I_compressed(i_c:i_c+sqrt(z)-1,j_c:j_c+sqrt(z)-1,c);

            %use net to decompress data
            decomp_x=net_dec(x(:));

            %transform back real valued data to k x k chunk and
            decomp_x=real_to_pixel(decomp_x,k);
            %set reconstructed image to computed values
            I_reconstructed(i:i+k-1,j:j+k-1,c)=uint8(decomp_x);
            j_c=j_c+sqrt(z);
        end
        i_c=i_c+sqrt(z);
    end
end
% add uncompressed rest of image not handled because of chunk size, to add
% for reconstuction

I_reconstructed(:,j+k:cols,:)=I(:,j+k:cols,:);
I_reconstructed(i+k:rows,:,:)=I(i+k:rows,:,:);
 
figure;
subplot(1,2,1),imshow(uint8(I)),title('Original image');
subplot(1,2,2),imshow(uint8(I_reconstructed)),title('Reconstructed image');
