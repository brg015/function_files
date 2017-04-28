function block_kept=first_level_expected_vectors(job_file)

try 
	% EP data
	data=job_file.matlabbatch{1}{1}.spm.stats.fmri_spec.sess;
catch err
	% PACT data
	try
		data=job_file.jobs{1}.stats{1}.fmri_spec.sess; 
	catch err
		try
		data=job_file.jobs{1}{1}.spm.stats.fmri_spec.sess;
		catch err
			data=job_file.matlabbatch{1}.spm.stats.fmri_spec.sess;
		end
	end
end

 for i=1:length(data)
	  [~,vecID,~]=fileparts(data(i).multi{1});
	  block_kept(i)=str2num(vecID(end));
 end