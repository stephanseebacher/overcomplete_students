function I_rec = Decompress(I_comp)

%decompress
U = double(I_comp.U)/100;
Z = double(I_comp.Z)/100;

tmp = U * Z;
raws= I_comp.raws;
cols=I_comp.cols;

%reassign pixel correctly
% for grayscale img
if (size(tmp,1) == 1)
    I_rec = reshape(tmp,[raws,cols]);
else
    for i=1:3
        I_rec(:,:,i) = reshape(tmp(i,:),[raws,cols]);
    end

end

%show reconstructed image
% figure
% imshow(I_rec)
% title('Reconstructed image')



