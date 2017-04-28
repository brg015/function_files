function path_fixed=rectify_path(path)
	file_parts=regexp(path,filesep,'split');
	file_parts=file_parts(~cellfun('isempty',file_parts));
	path_fixed='';
	for parts=1:length(file_parts), 
        if parts==1
            path_fixed=[file_parts{parts}]; 
        else
            path_fixed=[path_fixed filesep file_parts{parts}]; 
        end
	end
	path_fixed=[path_fixed filesep];
end