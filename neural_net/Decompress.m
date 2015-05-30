function I_rec = Decompress(I_comp)

%read data for recontruction
% I_compressed=double(I_comp.I)/10000;
number_bits=I_comp.number_bits;
quanitization_bits=I_comp.quanitization_bits;
compressed_data=I_comp.compressed_data;
rows=I_comp.image_size{1};
cols=I_comp.image_size{2};
colours=I_comp.image_size{3};
net_dec=I_comp.net_dec;
k=I_comp.image_size{4};
z=I_comp.image_size{5};
maxrows=I_comp.image_size{6};
maxcols=I_comp.image_size{7};

% SVD
I = I_comp.U * diag(I_comp.S) * I_comp.V';
I_compressed = reassemble_patches(I, I_comp.svdsize);

I_reconstructed=uint8(zeros(rows,cols,colours));

%counter cell of compressed data
counter_cell=1;
% use trained net to reconstuct each k*k chunk in data
for c=1:colours
    i_c=1;
    for i=1:k:maxrows
        j_c=1;
        for j=1:k:maxcols
            %extract squrt(z)x sqrt(z) chunk
%             x=I_compressed(i_c:i_c+sqrt(z)-1,j_c:j_c+sqrt(z)-1,c);
            
            %use compressed quantized data
            actual_compr=compressed_data{counter_cell};
            counter_cell=counter_cell+1;
            %decode quantized data
            x=extract_compr(actual_compr,number_bits,quanitization_bits);

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

I_reconstructed(:,j+k:cols,:)=I_comp.uncompressed_part{1};
I_reconstructed(i+k:rows,:,:)=I_comp.uncompressed_part{2};

figure;
imshow(uint8(I_reconstructed)),title('Reconstructed image');

I_rec = I_reconstructed;