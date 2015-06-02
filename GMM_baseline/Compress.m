function I_comp = Compress(I,nClusters)

% Your compression code goes here
[raws,cols,~] =size(I);
X=extract(I);
[~, U, ~, Z] = gmm(X, nClusters);

I_comp.U = U;
I_comp.Z = Z;
I_comp.raws = raws;
I_comp.cols = cols;

%show initial image
figure
imshow(I)
title('Initial Image')