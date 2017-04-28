function mkdir_tree(dir_tree)

parsed_tree=regexp(dir_tree,filesep,'split');
sub_folders=parsed_tree(~cellfun('isempty',parsed_tree));

% Append path with the filesep if it is needed
if strcmp(dir_tree(1),filesep)
    folder_search=filesep;
else
    folder_search=[];
end

for i=1:length(sub_folders) % Skip the root directory*
	folder_search=[folder_search sub_folders{i} filesep];
	if (~exist(folder_search,'dir') && i>1), 
        mkdir(folder_search); 
%         win_print(['Made Dir: ' folder_search]);
    end
end
