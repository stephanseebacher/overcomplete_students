function I_rec = Decompress(I_comp)

tmp = I_comp.U * I_comp.Z;
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
figure
imshow(I_rec)
title('Reconstructed image')



