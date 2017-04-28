function struct=flush_struct(struct)

if isempty(struct), return; end

if isfield(struct{1},'col')
	if ~isempty(struct)
		L=length(struct{1}.col);
		for i=2:length(struct)
			 C_len=length(struct{i}.col);
			 if C_len<L; for j=C_len+1:L
				  switch class(struct{i}.col)
						case 'cell', struct{i}.col{j}='';
						case 'double', struct{i}.col(j)=NaN;
			 end; end; end;
		end
	end
else
	fprintf('--Flush Struct--\n');
	fprintf('=> Failed to run due to lack of field "col"\n');
end