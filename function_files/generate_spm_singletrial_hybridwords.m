function SL_hemi_mode()
global SL;
%------------------------Micro------------------------------------%
        % Remove bw list comparisons... not easy as list are in randomly
        % ordered... but need to remove reduduncy i.e. repeats in the
        % matrix... never an ID repeat though...
        
        % And finally a run-equalize
        for ii=1:length(SL.design.ID_descrip)
            indx1=findstr('Run',SL.design.ID_descrip{ii});
            indx2=findstr('_Tri',SL.design.ID_descrip{ii});
            if ~isempty([indx1,indx2])
                try
                    ID_code(ii)=str2double(SL.design.ID_descrip{ii}(indx1+length('Run'):indx2-1));
                catch err
                    ID_code(ii)=NaN;
                end
            end
        end
        
        jb=[0 cumsum(SL.design.Box)];
        K1=zeros(jb(end),jb(end));
        % K2=zeros(jb(end),jb(end));
        
        KC=zeros(jb(end),jb(end));
        KF=zeros(jb(end),jb(end));
        KM=zeros(jb(end),jb(end));
        KH=zeros(jb(end),jb(end));
        
        KT=zeros(jb(end),jb(end));
        % Examine cells in the lower left (ER)
        I1=5:8;
        I2=1:4;
        for kk=1:4
           ii=I1(kk);
           jj=I2(kk);
           % Then, for each condition, must identify repeats...
           r=jb(ii)+1:jb(ii+1); % rows included    RetList
           c=jb(jj)+1:jb(jj+1); % columns included EncList

           V1=eye(length(r),length(c)); % must remain ones
           % V2=ones(length(r),length(c)); % must remain ones
           VC=zeros(length(r),length(c)); 
           VF=zeros(length(r),length(c)); 
           VM=zeros(length(r),length(c));
           VH=zeros(length(r),length(c)); 
           VT=zeros(length(r),length(c)); 
         
           
           % Then remove any identical trial matches that happen to be in
           % the off diaganol as well
           RM=ID_code(r); % Get ID match
           for aa=1:length(r)
              RMi=RM(aa);
              II=(RMi==RM);     % Find runs that don't match
              V1(aa,find(II))=1;       % Don't include them
           end

           K1(r,c)=V1; 
        end
        
        % Added mods on 10/12
        LN=length(SL.design.ID_idx);
        IL=SL.design.ID_idx(1:LN/2); % 1:72 ideally
        for ii=(LN/2+1):LN         
            % 1) Identify the rows included
            IV1=K1(ii,:);
            % 2) From this, determine missing items
            IV2=SL.design.ID_idx(logical(IV1)); % found
            IV3=setdiff(IL,IV2);                % missing
            % 3) Find those missing items
            [~,~,ILi]=intersect(IV3,IL);
            % 4) add them into the list
            K1(ii,ILi)=1;
        end % For every single retrieval trial
        
        %=================================================================%
        % Now modify existing matrices
        %=================================================================%
        for ii=1:length(SL.design.save_str)
            SL.design.anova{ii}.f{1}=SL.design.anova{ii}.f{1}.*K1;
            SL.design.anova{ii}.f{2}=SL.design.anova{ii}.f{2}.*K1;
            % SL.design.anova{ii}.f{3}=K2;
        end
        
        I1=SL.design.hemi_trial_counts_cfmh(:,2)==2;
        I2=SL.design.hemi_trial_counts_cfmh(:,2)==0;
        KF(I1,I1)=1;
        KC(I2,I2)=1;
        
        ii=5;
        SL.design.anova{ii}.f{1}=SL.design.anova{ii}.f{1}.*KC;
        SL.design.anova{ii}.f{2}=SL.design.anova{ii}.f{2}.*KC;
        
        ii=6;
        SL.design.anova{ii}.f{1}=SL.design.anova{ii}.f{1}.*KF;
        SL.design.anova{ii}.f{2}=SL.design.anova{ii}.f{2}.*KF;