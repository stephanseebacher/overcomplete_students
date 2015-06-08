function I_comp = Compress(I)

%assume I between 0 and 255
I=I*255;
[rows,cols,colours]=size(I);
%train on gray scale image if image is colored
if (colours > 1) 
    I_gray = double(rgb2gray(uint8(I))); 
else
    I_gray=I;
end

%compression with neural net
% choose training_samples kxk chunks unif at random to trian the nn
k=6;

% train neural net with z hidden values z<k*k, better be power of 2 to show
% compressed image afterwards
z=4;

% Number of bits for quanitization
quanitization_bits=3;

maxrows=floor(rows/k)*k-k;
maxcols=floor(cols/k)*k-k;

training_samples=300;
Data=zeros(k*k,training_samples);

%create training data
for t=1:training_samples
    i=randi(maxrows);
    j=randi(maxcols);


    %extract kxk chunk
    train_data=I_gray(i:i+k-1,j:j+k-1);
    
    %add to train data
    Data(:,t)= pixel_to_real( train_data );
end


%create net

% setdemorandstream(491218382) %used to avoid randomness, and get similar results after each training
%feedforwardnet very important! patternnet not working for example!
% net= feedforwardnet(z);

% use trained net instead of new one!
load(['trained_net_k_' num2str(k) '_z_' num2str(z) '.mat']);
% load('net_castle_20_iteration');
display('Trained net loaded and ready for further optimization.')

%target_data is equal to train_data
Target_Data=Data;

% Training paramters
%set particular training goal 
%TODO: choose carefully
net.trainParam.goal=0.001;
%max iterations
net.trainParam.epochs=30;
%max training time in seconds
net.trainParam.time=25; 

% set trainging function
% net.trainFcn ='trainlm'; % so far default used because faster

[net,~] = train(net,Data,Target_Data);
nntraintool

disp('Training Done.')

%choose configuration data randomly
i=randi(size(Data,2));
j=randi(size(Target_Data,2));

net_enc=get_encoding_net(net,k,z,Data(:,i));
net_dec=get_decoding_net(net,k,z,Target_Data(:,j));

%now encode all the image

%get image info % and adapt it to image depending on k
height = size(I, 1);
width = size(I, 2);
w_rest=mod(width,k);
h_rest=mod(height,k);

%add padding if not either col/row number not divisible by k (replicate last col/row)
%add columns
if (w_rest~=0)
    I =[ I repmat(I(:,width,:),[1 k-w_rest]) ];
    width=width+k-w_rest;
end

% add rows
if(h_rest~=0)
    I =[ I ; repmat(I(height,:,:),[k-h_rest 1])];
    height=height+k-h_rest;
end

%update this variable now
maxrows=height;
maxcols=width;
 

I_compressed=double(zeros((maxrows/k +1)*sqrt(z),(maxcols/k +1 )*sqrt(z),colours));
% I_compressed=double(zeros((maxrows/k)*sqrt(z),(maxcols/k)*sqrt(z),colours)); %optimized version

% use trained net to reconstuct each k*k chunk in data
%compressed and quantized data

%preallocate for speed up
compressed_data=int8(zeros(ceil(z*quanitization_bits/8),colours*maxrows/k*maxcols/k)); %e because then stored in 8 bit array in quanitiation
%counter cell array
counter_cell=1;

 
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
            
            %quanitize data for much compression to
            quantized_data=quantize(comp_x,quanitization_bits);
            compressed_data(:,counter_cell)=quantized_data;
            counter_cell=counter_cell+1;
            %compute compressed image
            %reshape data
            comp_x=reshape(comp_x,sqrt(z),sqrt(z));
            %set compressed image to computed values
            I_compressed(i_c:i_c+sqrt(z)-1,j_c:j_c+sqrt(z)-1,c)=double(comp_x);
            j_c=j_c+sqrt(z);
        end
        i_c=i_c+sqrt(z);
    end
    disp(['Compressing of colour channel ' num2str(c) ' done.']);
end

% tmp_I_compressed=double(zeros(z,maxrows/k * maxcols/k,colours));
% %optimized version
% for c=1:colours
%     I_reshaped=reshape(I(:,:,c),[k*k,maxrows/k*maxcols/k]);
%     
%     for i=1:size(I_reshaped,2)
%         %extract kxk chunk
%         x=I_reshaped(:,i);
%         %transform kxk chunk to real valued data
%         x=pixel_to_real(x);
% 
%         %use net to compress
%         comp_x=net_enc(x);
% 
%         %quanitize data for much compression to
%         quantized_data=quantize(comp_x,quanitization_bits);
%         compressed_data{i+(c-1)*size(I_reshaped,2)}=quantized_data;
% 
%         %compute compressed image
%         %set compressed image to computed values
%         tmp_I_compressed(:,i,c)=double(comp_x);
%     end
%     
%     disp(['Compressing of colour channel ' num2str(c) ' done.']);
%     
% end
% 
% %reshape compressed image
% for c=1:colours
%     I_compressed(:,:,c)=reshape(tmp_I_compressed(:,:,c),[(maxrows/k)*sqrt(z),(maxcols/k)*sqrt(z)]);
% end


figure
subplot(1,2,1)
imshow(uint8(I))
title('Original image')


subplot(1,2,2)
imshow(double(I_compressed))
title('Compressed image')


% SVD
% dsvd = 8;
% Isvd = extract_patches(I_compressed, dsvd);
% [Usvd, Ssvd, Vsvd] = svd( Isvd );
% % percent singular values considered
% prct_singval=0.6;
% ksvd = round(rank( Isvd ) * prct_singval);
% 
% I_comp.svdsize = size(I_compressed);
% I_comp.U = Usvd(:, 1:ksvd);
% I_comp.S = diag(Ssvd(1:ksvd, 1:ksvd));
% I_comp.V = Vsvd(:, 1:ksvd);

% I_comp.I = I_compressed;

I_comp.compressed_data=compressed_data;
I_comp.number_bits_encoded=quanitization_bits*z;
I_comp.quanitization_bits=quanitization_bits;
I_comp.net_dec = net_dec;
% add uncompressed rest of image not handled because of chunk size, to add
% for reconstuction
% I_comp.uncompressed_part={I(:,j+k:cols,:), I(i+k:rows,:,:)};
%add size image
I_comp.image_size={rows,cols,colours,k,z,maxrows,maxcols};