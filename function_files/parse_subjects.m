function subj=parse_subjects(subj,N_BATCHES,BATCH_N)

   switch class(subj{1})
       case 'char'
           temp_subj=subj;
       case 'struct'
           temp_subj=subj{1}.col;
       otherwise
           error('ERROR: Invalid subject list\n');
   end
   N=length(temp_subj);
   Parcel=int32(ceil(N/N_BATCHES));
   Run_N=((BATCH_N-1)*Parcel+1):(BATCH_N*Parcel);
   Run_N(Run_N>N)=[]; % Prevent too long
   switch class(subj{1})
       case 'char'
           for i=1:length(Run_N)
               subj_use{i}=subj{Run_N(i)};
           end
           clear subj; subj=subj_use;
       case 'struct'
           subj_use{1}.header='subj';
           subj_use{2}.header='pro';
           for i=1:length(Run_N)
               subj_use{1}.col(i)=subj{1}.col(Run_N(i));
               subj_use{2}.col(i)=subj{2}.col(Run_N(i));
           end
           clear subj; subj=subj_use;
   end