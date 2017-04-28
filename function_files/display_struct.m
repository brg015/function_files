function flag=display_struct(data,index,varargin)

flag=0;
class_index=class(index);
switch class_index
    case 'char'
        index=find(strcmp(index,data{1}.col));
        
        if isempty(index), fprintf('Subject not found...\n'); flag=1; return; end

        for i=1:length(data)
            class_data=class(data{i}.col(index));
            switch class_data
                case 'cell' 
                    if ~isempty(data{i}.col{index})
                        fprintf([n2sp(i,2) ': ' char(data{i}.header) ': ' char(data{i}.col(index))])
                        fprintf('\n');
                    else 
                        fprintf([n2sp(i,2) ': ' char(data{i}.header) ': ']);
                        fprintf('\n');
                    end
                case 'char'
                    fprintf([n2sp(i,2) ': ' char(data{i}.header) ': ' char(data{i}.col(index))])
                    fprintf('\n');
                otherwise
                    fprintf([n2sp(i,2) ': ' char(data{i}.header) ': ' num2str(data{i}.col(index))])
                    fprintf('\n');
            end
        end
    case 'cell'
        for i=1:length(data), headers_have{i}=data{i}.header; end
        header_index=strcmp(varargin{1},headers_have);
        for i=1:length(index)
            subj_index=find(strcmp(index{i},data{1}.col));
            if ~isempty(subj_index)
                fprintf([index{i} '\t' data{header_index}.col{subj_index} '\n']);
            else 
                fprintf([index{i} '\tNO DATA\n']);
            end
        end             
end