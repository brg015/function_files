function [struct,subj]=filter_struct(struct,scenario,varargin)

status={}; subj={}; timepoint='';
% With no inputs, the user should be filtering

switch scenario
    case 'filter'
        display_headers(struct);
        fprintf('Which columns would you like e.g. [1:3 5:8 9] ... \n\t');
        response=input('','s');
        fprintf('\n'); vect_col=eval(response); clear response;

        c=1;
        for i=vect_col
            struct1{c}.header=struct{i}.header;
            struct1{c}.col=struct{i}.col;
            c=c+1;
        end
        clear struct; struct=struct1;

        fprintf('You have chosen to include the following ...\n');
        display_headers(struct)

        response='Y';

        while strcmp(response,'Y')
            fprintf('Would you like to filter the columns [Y/N] ... ');
            response=input('','s'); fprintf('\n');
            if strcmp(response,'Y'),
                struct_temp=filter_col(struct);
                clear struct; struct=struct_temp;
            else
                break
            end
        end
        
    case 'pull' 
        c=1; missing=0; 
        subj=varargin{1};

        % Can pull subject list exactly here
        index=[];
        for i=1:length(subj)
            found=find(strcmpi(subj{i},struct{1}.col));
				if ~isempty(found)
					index(c)=found; 
					c=c+1; 
				else
					missing=missing+1;
				end
		  end
        fprintf(['  ' num2str(missing) ' Subjects are missing\n']);
  
        for i=1:length(struct)
            struct_temp{i}.header=struct{i}.header;
            struct_temp{i}.col=struct{i}.col(index);
        end
        clear struct; struct=struct_temp; clear struct_temp;
       
end
end
%=========================================================================%
% Internal Function: display_headers
%=========================================================================%
function display_headers(struct)
for i=1:length(struct), 
    fprintf([num2str(i) ': ' char(struct{i}.header) '\n'])
end
fprintf('\n');
end

%=========================================================================%
% Internal Function: filter_col
%=========================================================================%
function struct=filter_col(struct)
    display_headers(struct)
    fprintf('Which column would you like to filter ... ');
    response=input('','s');
    N=eval(response); clear response;
    Random_data=int32((length(struct{1}.col)-1).*rand(15,1)+1);
    response=class(struct{N}.col(1)); % Assumes columns are uniform class
    fprintf(['Column was determined to contain class : ' response '\n']);
    
    fprintf('Is this good [y/n]: ');
    force_cast=input('','s');
    if strcmpi(force_cast,'n'),
        class_type=input('Force to [cell/double]: ','s');
        response=class_type;
        switch class_type
            case 'cell'
                for i=1:length(struct{N}.col)
                    struct{N}.col{i}=struct{N}.col(i);
                end
            case 'number'
                for i=1:length(struct{N}.col)
                    try
                        struct{N}.col(i)=str2num(cell2mat(struct{N}.col{i}));
                    catch err
                        struct{N}.col(i)=[];
                    end
                end
        end
    end
    
    switch response
        case 'double'
            % Make sure no dobules in cell array
            empties=find(isempty(struct{N}.col));
            struct{N}.col(empties)=[];
            fprintf('Examples of data include the following \n');
            for i=1:length(Random_data)
                fprintf(['\t' char(struct{1}.col((Random_data(i)))) ': \t' ...
                    num2str(struct{N}.col(Random_data(i)))]);
                fprintf('\n');
            end
            fprintf('An exact match [M] or range [R] ... ');
            Nresponse=input('','s'); 
            switch Nresponse
                case 'M'
                    fprintf('\tWhat value ... ');
                    var{1}=input('','s');
                    v(1)=eval(var{1});
                    index=find(struct{N}.col==v(1));
                case 'R'
                    fprintf('\tGreater Than or Equal to ... ');
                    var{1}=input('','s');
                    v(1)=eval(var{1});
                    fprintf('\tLess Than or Equal to... ');
                    var{2}=input('','s');
                    v(2)=eval(var{2});
                    index_temp{1}=find(struct{N}.col>=v(1));
                    index_temp{2}=find(struct{N}.col<=v(2));
                    index=intersect(index_temp{1}, index_temp{2});
            end
        case 'cell'
            % Make sure no dobules in cell array
            empties=find(cellfun('isempty',struct{N}.col));
            struct{N}.col(empties)={''};
            fprintf('Examples of data include the following \n');
            for i=1:length(Random_data)
                if length(struct{N}.col)>=Random_data(i),
                    if ~isempty(struct{N}.col{Random_data(i)})
                        fprintf(['\t' char(struct{1}.col((Random_data(i)))) '\t' char(struct{N}.col(Random_data(i))) '\n']);
                    else
                        fprintf(['\t' char(struct{1}.col((Random_data(i)))) '\n']);
                    end
                end
            end
            fprintf('How many strings do you want to look for ... ');
            Sresponse=input('','s'); 
            SN=eval(Sresponse); 
            for i=1:SN
                fprintf(['\tString ' num2str(i) ' is : ']);
                SNresponse{i}=input('','s');
                index_temp=strmatch(SNresponse{i},struct{N}.col);
                if i==1, index=index_temp; end
                if i>1, index=union(index,index_temp); end            
            end
    end
    
    if exist('index','var');
        for i=1:length(struct)
            index_in=[]; index_use=[];
            index_in=find(index<=length(struct{i}.col));
            index_use=index(index_in);
            struct_temp{i}.header=struct{i}.header;
            struct_temp{i}.col=struct{i}.col(index_use);
            
        end
        org_L=length(struct{1}.col);
        clear struct;
        struct=struct_temp;
        new_L=length(struct{1}.col);
        fprintf(['Original size was ' num2str(org_L) '\n']);
        fprintf(['New size is ' num2str(new_L) '\n\n']);
    end
 
end
