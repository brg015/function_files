function index=pull_headers(data,header_names,how_many)

for i=1:length(data), header_have{i}=char(data{i}.header); end

index=[];
for i=1:length(header_names)
	temp_index=strsearch(header_names{i},header_have);
	switch how_many
		case 'all'
			index=[index temp_index];
		case 'one'
			if ~isempty(temp_index), index=[index temp_index(1)]; end
		case 'strt_one'
			if ~isempty(temp_index)
				N=length(header_names{i});
				if strcmp(header_names{i},header_have{temp_index(1)}(1:N))
					index=[index temp_index(1)];
				end
			end
		case 'strt_all'
			if ~isempty(temp_index)
				N=length(header_names{i});
				for j=1:length(temp_indx)
					if strcmp(header_names{i},header_have{temp_index(j)}(1:N))
						index=[index temp_index(j)];
					end
				end
		end
	end
end
