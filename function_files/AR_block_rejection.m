% BR Geib
% AR Block processing
%
function [processing,blx]=AR_block_rejection(processing,ID)

TR_limit=2.4;
thresh_per_limit=NaN;

fprintf(' AR Contrast Level Rejection Enacted\n');
blx=[];
pro_dir=[processing.pre.pro_dir ID processing.pre.pro_dir_sub];
for b=1:length(processing.pre.block)
	AR_file=[pro_dir processing.pre.block(b).dir ...
		'art_data_b' num2str(b) '.mat'];
	if exist(AR_file,'file'),
		load(AR_file);
		if art_stats.TRmm < TR_limit,
			fprintf(['  Block ' num2str(b) ': accepted\n']);
			blx=[blx, b];
		else
			fprintf(['  Block ' num2str(b) ': rejected\n']);
		end
	end
end

if ~isempty(blx)
	N=length(processing.contrast.basis);
	c=1; for b=blx
		processing.contrast.basis{N+c}=['Sn(' num2str(b) ')']; c=c+1;
	end
end
	

end