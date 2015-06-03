function I_comp = Compress(I)

nClusters=3;
% Your compression code goes here
[raws,cols,~] =size(I);
X=extract(I);
[~, U, ~, Z] = gmm(X, nClusters);

% I_comp.U = U;
% I_comp.Z = Z;

%compress more
I_comp.U = uint8(U*100);
I_comp.Z = uint8(Z*100);

I_comp.raws = raws;
I_comp.cols = cols;

%show initial image
% figure
% imshow(I)
% title('Initial Image')
