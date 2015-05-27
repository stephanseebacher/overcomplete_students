function [code, index] = bwt_encode ( v )
% Burrows-Wheeler-Transformation encoder
%  V is the vector to be encoded

% create one looooong vector
% also works as sanity check if input is not row vector
v = reshape(v, 1, []);
l = length(v);

% generate cyclic permutations
perms = zeros(l, l);
for i = 1 : l
    perms(i, :) = [v(i : l) v(1 : i-1)];
end

% sort by rows
sorted_perms = sortrows(perms);

% preallocation
code = zeros(1, l);
index = 0;

% get last elements from sorted_perms => the code
for i = 1 : length(sorted_perms)
    code(1, i) = sorted_perms(i, l);
    % check and store the index too
    if index == 0 && isequal(sorted_perms(i, :), v)
        index = i;
    end
    
end

end