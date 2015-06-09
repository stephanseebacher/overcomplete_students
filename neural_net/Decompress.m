function I_rec = Decompress(I_comp)
%read compressed image
% I_compressed=double(I_comp.I);

% get compressed data
compressed_data=I_comp.compressed_data;

% read image properties
rows=I_comp.image_size{1};
cols=I_comp.image_size{2};
colours=I_comp.image_size{3};
maxrows=I_comp.image_size{4};
maxcols=I_comp.image_size{5};
% read compression properties
k=I_comp.comp_properties{1};
z=I_comp.comp_properties{2};
quanitization_bits=I_comp.comp_properties{3};

% compute then number of bits encoded per patch
number_bits_encoded=z*quanitization_bits;

% get decoding net data
net_dec_LW=I_comp.net_dec_data{1};
net_dec_b=I_comp.net_dec_data{2};
net_dec_configure_data=I_comp.net_dec_data{3};
% get decoding net using this info
net_dec=get_decoding_net_2(net_dec_LW,net_dec_b,k,z,net_dec_configure_data);
% net_dec=I_comp.net_dec;


% SVD
% I_svd = I_comp.U * diag(I_comp.S) * I_comp.V';
% I_compressed = reassemble_patches(I_svd, I_comp.svdsize);

% preallocate reconstructed image
I_reconstructed=uint8(zeros(maxrows,maxcols,colours));

%counter cell of compressed data
counter_cell=1;
% use trained net to reconstuct each k*k chunk in data
for c=1:colours
    % variable used for image reconstruction
    i_c=1;
    for i=1:k:maxrows
        % variable used for image reconstruction
        j_c=1;
        for j=1:k:maxcols
            %extract squrt(z)x sqrt(z) chunk of compressed image
%             x=I_compressed(i_c:i_c+sqrt(z)-1,j_c:j_c+sqrt(z)-1,c);
            
            %get cu compressed quanitized data
            actual_compr=compressed_data(:,counter_cell);
            counter_cell=counter_cell+1;
            %decode quantized data

            x=extract_compr(actual_compr,number_bits_encoded,quanitization_bits);

            %use net to decompress data
            decomp_x=net_dec(x(:));

            %transform back real valued data to k x k chunk and
            decomp_x=real_to_pixel(decomp_x,k);
            
            
            %set reconstructed patch to mean of reconstructed values
%             decomp_x_mean=ones(size(decomp_x))*mean(mean(decomp_x));
            
            %apply gaussian filter on patch
%             decomp_x_gauss=decomp_x;
%             h = fspecial('gaussian',5);
%             decomp_x_gauss=imfilter(decomp_x_gauss,h,'replicate');
            
            %set reconstructed image to computed values
            I_reconstructed(i:i+k-1,j:j+k-1,c)=uint8(decomp_x);
            j_c=j_c+sqrt(z);
        end
        i_c=i_c+sqrt(z);
    end
    disp(['Decompressing of colour channel ' num2str(c) ' done.']);
end

% %optimized version
% tmp_I_reconstructed=uint8(zeros(k*k,length(compressed_data)/colours,colours));
% for c=1:colours
%     for i=1:(length(compressed_data)/colours)        
%         %extract squrt(z)x sqrt(z) chunk
% %       x=I_compressed(i_c:i_c+sqrt(z)-1,j_c:j_c+sqrt(z)-1,c);
% 
%         actual_compr=compressed_data{i+(c-1)*(length(compressed_data)/colours)};
%         %decode quantized data
%         x=extract_compr(actual_compr,number_bits,quanitization_bits);
% 
%         %use net to decompress data
%         decomp_x=net_dec(x(:));
% 
%         %transform back real valued data to k x k chunk and
%         decomp_x=real_to_pixel(decomp_x,k);
%         %set reconstructed image to computed values
%         tmp_I_reconstructed(:,i,c)=uint8(decomp_x(:));
%     end
%     
%     disp(['Decompressing of colour channel ' num2str(c) ' done.']);
%     
% end
% 
% %reshape decompressed image
% for c=1:colours
%     I_reconstructed(:,:,c)=reshape(tmp_I_reconstructed(:,:,c),[maxrows,maxcols]);
% end


%crop paddding
I_reconstructed=I_reconstructed(1:rows,1:cols,:);

%show reconstructed image
figure
imshow(uint8(I_reconstructed));
title('Reconstructed image')

% scale back reconstructed image to exepcted range values
I_rec = double(I_reconstructed)/255;