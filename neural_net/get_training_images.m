
%read images from data set
folder_name='101_ObjectCategories';
direc=dir(file_name);

% get all subfolder names
subfolder_names={direc.name};

out_folder_name='Training_Set';

%get n images from each folder
n=1;
for i = 3:length(subfolder_names) % runing through the folder
    current_subfolder_path=[folder_name '/' subfolder_names{i}];
    %list all files in current subfolder
    file_list = dir(current_subfolder_path);
    
    images_names={file_list.name};
    %copy n of them in new folder
    for j=3:3+n-1
        % first rename file because naming issue
        old_name_path=[current_subfolder_path '/' images_names{j}];
        new_name_path=[current_subfolder_path '/' subfolder_names{i} '_' images_names{j}];
        movefile(old_name_path, new_name_path);
        copyfile(new_name_path,out_folder_name);
    end
    
end


