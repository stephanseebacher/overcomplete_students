function X = extract(I)
    % for grayscale img
    if (size(I,3) == 1)
        [raws,cols]= size(I);
        X = reshape(I,[1,raws*cols]);
    else
        % be careful with size for 3 dimensional arrays [raws,cols]=
        % size(I); won t work
        [raws,cols,~]= size(I);
        for i=1:3
            X(i,:)= reshape(I(:,:,i),[1,raws*cols]);
        end
        
    end
end