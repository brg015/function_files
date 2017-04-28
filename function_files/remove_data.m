% BR Geib 2013
% Function File
% r_struct=remove_data(index,o_struct,rc)
%
% Description: This function removes either rows or columns from a data
% structure.
%
% Inputs
%	index    => kill index (remove these)
%	o_struct => original structure
%	rc       => 'row' or 'col' specification
% Outputs
%	r_struct => reduced structure
%
function r_struct=remove_data(index,o_struct,rc)

switch rc
	case 'row'
		% Reform headers
		for i=1:length(o_struct)
			 r_struct{i}.header=o_struct{i}.header;
		end

		c=1;
		for i=1:length(o_struct{1}.col)
			 kill=sum(index==i);
			 if kill==0
				  for j=1:length(o_struct),
						try
							 r_struct{j}.col{c}=o_struct{j}.col{i};
						catch err
							 r_struct{j}.col(c)=o_struct{j}.col(i);
						end
				  end
				  c=c+1;
			 end
		end
	case 'col'
		c=1; SAVE_idx=setdiff(1:length(o_struct),index);
		for i=SAVE_idx
			 r_struct{c}.header=o_struct{i}.header;
			 r_struct{c}.col=o_struct{i}.col;
			 c=c+1;
		end
		
	otherwise
		fprintf('Warning: no changes made, rc must be "row" or "col"\n');
end