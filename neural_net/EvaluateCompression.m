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
    
    disp(['quadratic error of current image: ' num2str(Errors(k))])
    disp(['compression rate of current image: ' num2str( Comp_rates(k))])
    
    k = k+1;
    
end

Result(1) = mean(Errors);
Result(2) = mean(Comp_rates);

time_for_everything= toc(tstart);
disp(['Time for everything: ' num2str(time_for_everything)])

disp(['Average quadratic error: ' num2str(Result(1))])
disp(['Average compression rate: ' num2str(Result(2))])


%%
% with SVD and Quanitization
% Average quadratic error: 25656.004
% Average compression rate: 0.64525

% Time for everything: 451.9379
% Average quadratic error: 28445.217
% Average compression rate: 0.65351
% 
% Time for everything: 458.6385
% Average quadratic error: 29311.4582
% Average compression rate: 0.65666

% no svd 

% Quanitizaiton 3 with trained_net on 100+ images
% Time for everything: 444.938
% Average quadratic error: 0.024012
% Average compression rate: 0.27866

% Quanitizaiton 3 with net_castle_20_iteration
% Time for everything: 532.0234
% Average quadratic error: 0.045942
% Average compression rate: 0.27866

% Quanitizaiton 3 with trained_net on 100+ images trained for longer time
% Time for everything: 439.1995
% Average quadratic error: 0.029787
% Average compression rate: 0.27866

% with modif on quanitize function
% Time for everything: 443.3492
% Average quadratic error: 0.013465
% Average compression rate: 0.27866

% 
% Time for everything: 427.6279
% Average quadratic error: 0.013461
% Average compression rate: 0.27866

% k=12 and z=36
% Time for everything: 198.5396
% Average quadratic error: 0.034515
% Average compression rate: 0.15565

% k=12 and z=49
% Time for everything: 225.7273
% Average quadratic error: 0.050408
% Average compression rate: 0.16792

% Best results so far. Training has an uttermost importance! Here trained for 10 mins
% k=12 and z=49
% Time for everything: 229.8597
% Average quadratic error: 0.018115
% Average compression rate: 0.16792

% very good quality but worse compression
% k=7 and z=16
% Time for everything: 407.8483
% Average quadratic error: 0.0087692
% Average compression rate: 0.32517

% k=6, z=4 ; 3 bit qanitization
% Time for everything: 442.6109
% Average quadratic error: 0.0052875
% Average compression rate: 0.41558

% From Now: Big Modif: int8 array used instead of
% cell array!!

% k=6, z=4 ; 2 bit qanitization and 
% Time for everything: 428.3418
% Average quadratic error: 0.01186
% Average compression rate: 0.019663
% ratio: 1.6579

% k=6, z=4 ; 3 bit qanitization
% Time for everything: 438.1732
% Average quadratic error: 0.0053232
% Average compression rate: 0.023166
% ratio: 4.3519