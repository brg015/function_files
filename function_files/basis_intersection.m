%=========================================================================%
% function: from GLM 
%=========================================================================%
function idx_r=basis_intersection(SPM,force_inter,basis_check,idx)
	if basis_check==1,
		cr_temp=[];
		for j=1:length(force_inter)
			 cr=strfind({SPM.Vbeta.descrip},force_inter{j});
			 cr_temp = [cr_temp find(~cellfun('isempty',cr))];
		end
		
		idx_keep=intersect(idx,cr_temp);
		clear idx; idx_r=idx_keep;
	else
		idx_r=idx;
	end
end
