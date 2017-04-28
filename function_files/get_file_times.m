% B.R.Geib Winter 2012
%
% Pulls file times and names
function data=get_file_times(file_dir,suffix,ret,identifier)

tempfile='tempfile';
eval(['!ls -l ' file_dir '*' suffix ' | cut -d" " -f6,7,8,9,10,11 > ' tempfile])

fid=fopen(tempfile);
data{2}.header='date';
data{1}.header='filename';
data{3}.header='number';
data{4}.header='session';

% Read in the data
count=1;

while 1
    line=fgetl(fid);
    if ~ischar(line), break, fclose(fid); end
    split{count}=strread(line,'%s','delimiter',' ');
    % Initialize empty
    data{1}.col{count}={''};
    data{2}.col{count}={''};
    data{3}.col{count}={''};
    data{4}.col{count}={''};
    % Find the file name
    fname_index=find(~cellfun('isempty',strfind(split{count},identifier)));
    if ~isempty(fname_index),
        split{count}{fname_index};
        [rut,nam,suf]=fileparts(split{count}{fname_index});
        cutup=strread(nam,'%s','delimiter','-');
        try
            tempNum=str2num(cutup{2});
            Num=num2str(tempNum);
            data{3}.col{count}=Num;
        catch err
        end
        try
            tempSes=str2num(cutup{3}(1));
            Ses=num2str(tempSes);
            data{4}.col{count}=Ses;
        catch err
        end
        if ret==1, data{1}.col{count}=[nam,suf]; end
        if ret==0, data{1}.col{count}=[nam]; end
    end
    for i=1:length(split{count}),
        % Find the data
        if isdate(split{count}{i}),
            if length(split{count}{i})>5
                data{2}.col{count}=split{count}{i};
            end
        end
    end
    count=count+1;
end

end
