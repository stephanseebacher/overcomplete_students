function I_comp = Compress(I)

% Your compression code goes here
d = 15;
k = 100;

% get patches
X = extract(I,d);

% do SVD 
[U, S, V] = svd(X);

%I_comp.I = I; % this is just a stump to make the evaluation script run, replace it with your code!
I_comp.U = U(:, 1:k);
I_comp.S = diag(S(1:k, 1:k));
I_comp.V = V(:, 1:k);
I_comp.size = size(I);
end
