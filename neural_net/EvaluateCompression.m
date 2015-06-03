% Measure approximation error and compression ratio for several images.
%
% NOTE Images must be have .jpg ending and reside in the same folder.

file_list = dir(); 
k = 1;

Errors = []; % mean squared errors for each image would be stored here
Comp_rates = []; % compression rate for each image would be stored here

%timing for everything
tstart=tic;

for i = 3:length(dir) % runing through the folder
    
    file_name = file_list(i).name; % get current filename
    
    if(max(file_name(end-3:end) ~= '.jpg')) % check that it is an image
        continue;
    end
    
    % Read image, convert to double precision and map to [0,1] interval
    I = imread(file_name); 
    I = double(I) / 255; 
    
    size_orig = whos('I'); % size of original image
    %timiings added
    tic;
    I_comp = Compress(I); % compress image
    t_comp=toc;
    
    disp(['Time for compression: ' num2str(t_comp)])
    
    tic;
    I_rec = Decompress(I_comp); % decompress it
    t_decomp=toc;
   
     disp(['Time for decompression: ' num2str(t_decomp)])
     
    % Measure approximation error
    Errors(k) = mean(mean(mean( ((I - I_rec) ).^2)));

    
    % Measure compression rate
    size_comp = whos('I_comp'); % size of compresseed image
    
    Comp_rates(k) = size_comp.bytes / size_orig.bytes; 
    
    k = k+1;
    
end

Result(1) = mean(Errors);
Result(2) = mean(Comp_rates);

time_for_everything= toc(tstart);
disp(['Time for everything: ' num2str(time_for_everything)])

disp(['Average quadratic error: ' num2str(Result(1))])
disp(['Average compression rate: ' num2str(Result(2))])

%%
% % result with k=8 z=36 and 4 iter (mean)
% Average quadratic error: 20.8172
% Average compression rate: 4.8866

% with SVD and Quanitization
% Average quadratic error: 25656.004
% Average compression rate: 0.64525
% 
% Time for everything: 439.3128
% Average quadratic error: 28476.6592
% Average compression rate: 0.63438