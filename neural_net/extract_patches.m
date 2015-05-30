function Iout = extract_patches ( I, p )

% number of rows and columns to add in pre-processing step
[fill_rows, fill_cols] = f(size(I), p);

if (fill_rows ~= 0) || (fill_cols ~= 0)
    % preallocate fixed matrix
    Ifixed = zeros(size(I, 1) + fill_rows, size(I, 2) + fill_cols, size(I, 3));
    
    % pre-process (for every color channel)
    for i = 1:size(I,3)
        % fills matrix with rows and columns so that patch size 
        % divides evenly
        It = [I(:,:,i); repmat(I(size(I,1),:,i), fill_rows, 1)];
        Ifixed(:,:,i) = [It repmat(It(:,size(I,2)), 1, fill_cols)];
    end
    
else
    % no rows and columns need to be added? great!
    Ifixed = I;
end

% preallocate result matrix FOR TEH SPEED
Iout = zeros(p^2, numel(Ifixed)/p^2);

% helper variable - indicates current Iout column
current = 1;

% extract features
% for every color channel
for i = 1:size(Ifixed, 3)
    for j = 0:size(Ifixed, 1) / p - 1
        for k = 0:size(Ifixed, 2) / p - 1
            % get a patch, vectorize it and throw it into the result matrix
            patch = Ifixed(j*p+1 : j*p+p, k*p+1 : k*p+p, i);
            Iout(:, current) = patch(:);
            current = current+1;
        end
    end
end
end