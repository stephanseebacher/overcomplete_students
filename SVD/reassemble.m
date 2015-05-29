function I_re = reassemble( Ipatched, original_dim )
%Iout is 2dim

% the block size -> d*d patches got transformed into a column vector
d = sqrt(size(Ipatched, 1));

% if it was a greyscale pic (only 2 dimensions), set 
% third dimension to one for the outer loop
if numel(original_dim) < 3
    original_dim(3) = 1;
end

% preallocation for speed (at least that's what MATLAB says)
I_re = zeros(original_dim);

% column being processed in the loop = Ipatched(:, current)
current = 1;

for d3 = 1 : original_dim(3)
    for row = 1 : d : original_dim(1)
        current_patch = zeros(d, size(Ipatched, 2));
        for col = 1 : d : original_dim(2)
            % reshape the current column into a d*d block and 
            % attach it to the current_patch temporary var
            % size(current_patch) is something like [d cols(Ipatched)]
            current_patch(:, col : col + d -1) = reshape(Ipatched(:, current), d, d);
            current = current + 1;
        end
        % read only the original columns into the result matrix
        I_re(row : row + d - 1, :, d3) = current_patch(:, 1 : original_dim(2));
    end
end
% we still have all rows, including the excess ones from fillung up
% so we remove them
I_re = I_re(1 : original_dim(1), :, :);
end