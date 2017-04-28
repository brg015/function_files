function process_behave_data_v3(behav)
% Future Updates:
% Look at creating compiled measures w/ output
%=========================================================================%
%% Declare Variables
%=========================================================================%
run_filters={'base'};

switch behav.type
    case 'behav'
        col{1}={'B' 'F' 'G' 'J' 'L' 'M'};
        headers{1}={'block' 'code1' 'code2' 'RT' 'r_N' 'button'};
        col{2}={'B' 'F' 'G' 'K'  'M' 'N'};
        headers{2}={'block' 'code1' 'code2' 'RT'  'r_N' 'button'};
        col{3}={'B' 'F' 'G' 'K'  'M' 'N' 'D'};
        headers{3}={'block' 'code1' 'code2' 'RT' 'r_N' 'button' 'ans_afc' };    
    case 'eeg'
        % Output jitters as well, thus columns change
        col{1}={'B' 'F' 'G' 'L' 'N' 'O'};
        headers{1}={'block' 'code1' 'code2' 'RT' 'r_N' 'button'};
        col{2}={'B' 'F' 'G' 'M' 'O' 'P'};
        headers{2}={'block' 'code1' 'code2' 'RT'  'r_N' 'button'};
        col{3}={'B' 'F' 'G' 'M' 'O' 'P' 'D'};
        headers{3}={'block' 'code1' 'code2' 'RT' 'r_N' 'button' 'ans_afc' };
end

key_cor=0;
key_inc=1;
key_NR=-1;
key_ER=-2;
key_catch=[-2 5 6 9 10];
key_hi=[8 4 7 11];
key_lo=[9 5 6 10];

Ef_idx=1; 
R1f_idx=2; 
R2f_idx=3;
    
bugger=0;
%=========================================================================%
%% Declare Header Information
%=========================================================================%
N=430;

wrk_dir=fullfile('D:\Data\','SEFER\');
edate='Stimuli06192014';
design.file=fullfile(wrk_dir,'Presentation',edate,'v5','stimuli_list_codes.csv');
design.col={'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N'};
design.head={'ID' 'stim' 'exemplar' 'name' 'domain' ...
    'category' 'size' 'letter' 'catch' 'code1' ...
    'code2' 'Old' 'Catch' 'L'};
data=excel_reader(fullfile(design.file),design.col,design.head);
c1_idx=strcmp(design.head,'code1');
c2_idx=strcmp(design.head,'code2');
old_idx=strcmp(design.head,'Old');
catch_idx=strcmp(design.head,'Catch');
left_idx=strcmp(design.head,'L');
cat_idx=strcmp(design.head,'category');

for ii=1:N
    code_mat(ii,1)=str2double(data{c1_idx}.col{ii});
    code_mat(ii,2)=str2double(data{c2_idx}.col{ii});
    ans_ctc(ii)=str2double(data{catch_idx}.col{ii});
    ans_old(ii)=str2double(data{old_idx}.col{ii});
    ans_afc(ii)=str2double(data{left_idx}.col{ii});
end

category_u=unique(data{cat_idx}.col);
for ii=1:length(category_u),
    F{ii}.vect=strcmp(category_u{ii},data{cat_idx}.col);   
    F{ii}.name=category_u{ii}; F{ii}.d=1;
end
% Load in the following variables - I think these are fully sufficient for
% any analysis that I'd wish to conduct.
% code 1
% code 2
% RT
% r_N
% button

save_file{1}='enc_save.csv'; % Encoding file
save_file{2}='ret_save.csv'; % Retrieval file
save_file{3}='afc_save.csv'; % AFC file
sess{1}='1'; sess{2}='2'; sess{3}='2';

M_headers={'E1_catch_R' 'E1_catch_hit' 'E1_catch_RT' ...
        'R1_hc' 'R1_hit' 'R1_miss' 'R1_cr' 'R1_fa' 'R1_RT' ...
        'R2_hc' 'R2_hit' 'R2_miss' 'R2_cr' 'R2_fa' 'R2_RT' 'R2_s' ...
        'R1_e' 'R2_e' 'R1R2_ON' 'R1R2_NO' 'E_block'};
Mc={0,0,0,...
    0,[5 6],[5 6],[7 8],[7 8],0,...
    0,[11 12],[11 12],[13 14],[13 14],0,0,0,0,[19,20,22,23],[19,20,22,23],0,[19,20,22,23],[19,20,22,23]};
ML=length(M_headers);

%=========================================================================%
%% Subject specific processing
%=========================================================================%
subj_str='subject';
    
for s=1:length(behav.subjects) 
    switch behav.hc
        case 0
            save_name=fullfile(behav.save_dir,'pre',[subj_str behav.subjects{s} '.csv']);
            save_name_RT=fullfile(behav.save_dir,'pre',[subj_str behav.subjects{s} '_RT.csv']);
        case 1 % Only HC count as hits
            save_name=fullfile(behav.save_dir,'pre_hc',[subj_str behav.subjects{s} '.csv']);
            save_name_RT=fullfile(behav.save_dir,'pre_hc',[subj_str behav.subjects{s} '_RT.csv']);
        case 2 % Only HC count as hits
            save_name=fullfile(behav.save_dir,'pre_hc_only',[subj_str behav.subjects{s} '.csv']);
            save_name_RT=fullfile(behav.save_dir,'pre_hc_only',[subj_str behav.subjects{s} '_RT.csv']);
        case 3
            save_name=fullfile(behav.save_dir,'pre_hc_toss',[subj_str behav.subjects{s} '.csv']);
            save_name_RT=fullfile(behav.save_dir,'pre_hc_toss',[subj_str behav.subjects{s} '_RT.csv']);
        case 4
            save_name=fullfile(behav.save_dir,'pre_lc_only',[subj_str behav.subjects{s} '.csv']);
            save_name_RT=fullfile(behav.save_dir,'pre_lc_only',[subj_str behav.subjects{s} '_RT.csv']);
    end
    if ~exist(fullfile(behav.save_dir,'pre_lc_only'),'dir'),
        mkdir(fullfile(behav.save_dir,'pre_lc_only'));
    end
        
%     if exist(save_name,'file'), continue; end
    display(['  Preprocessing: ' behav.subjects{s}]);
    % Creating data_mats [Nt X (code1,code2,RT,button)] from the subjects
    % individual save files
    
    block_idx=1;
    RT_idx=4; 
    b1_idx=5; 
    b2_idx=6; 
    ans_afc_idx=7;

    for f=1:3
        load_file=fullfile(behav.dir,[subj_str behav.subjects{s} sess{f}],save_file{f});
        if exist(load_file,'file')
            temp=excel_reader(load_file,col{f},headers{f});
            Nt=length(temp{1}.col);
            c=1;
            for jj=1:length(temp)
                if ~strcmp(temp{jj}.header,'x')
                    for kk=1:Nt, data_mat{f}(kk,c)=str2double(temp{jj}.col{kk}); end
                    c=c+1;
                end
            end
        else
            data_mat{f}=[];
        end
    end
    %---------------------------------------------------------------------%
    % HC only analysis 
    %---------------------------------------------------------------------%
    if behav.hc==1
       % in data_mat{2} & data_mat{3}
       %   col 5 : 9 -> 6
       %   col 6 : 0 -> 1 (of same index)
       II=find(data_mat{2}(:,5)==9);
       data_mat{2}(II,5)=6;
       data_mat{2}(II,6)=1;
       II=find(data_mat{3}(:,5)==9);
       data_mat{3}(II,5)=6;
       data_mat{3}(II,6)=1;
    elseif behav.hc==2 % HC items only
        % in data_mat{2} & data_mat{3}
        %   col 5 : 9 -> 6
        %   col 6 : 0 -> 1 (of same index)
        % LC responses i.e. 5 6 9 10 are all NR now
        for uu=2:3
            II=find(data_mat{uu}(:,5)==5);
            data_mat{uu}(II,5)=-1;
            data_mat{uu}(II,6)=-1;
            II=find(data_mat{uu}(:,5)==6);
            data_mat{uu}(II,5)=-1;
            data_mat{uu}(II,6)=-1;
            II=find(data_mat{uu}(:,5)==9);
            data_mat{uu}(II,5)=-1;
            data_mat{uu}(II,6)=-1;
            II=find(data_mat{uu}(:,5)==10);
            data_mat{uu}(II,5)=-1;
            data_mat{uu}(II,6)=-1;
        end
    elseif behav.hc==3
       % in data_mat{2} & data_mat{3}
       %   col 5 : 9 -> 6
       %   col 6 : 0 -> 1 (of same index)
       % Here we're just throwing out instead of tossing
       II=find(data_mat{2}(:,5)==9);
       data_mat{2}(II,5)=-1;
       data_mat{2}(II,6)=-11;
       II=find(data_mat{3}(:,5)==9);
       data_mat{3}(II,5)=-1;
       data_mat{3}(II,6)=-1; 
    elseif behav.hc==4 % HC items only
        % in data_mat{2} & data_mat{3}
        %   col 5 : 9 -> 6
        %   col 6 : 0 -> 1 (of same index)
        % HC respones ie. 7 8 11 12 are all NR now
        for uu=2:3
            II=find(data_mat{uu}(:,5)==7);
            data_mat{uu}(II,5)=-1;
            data_mat{uu}(II,6)=-1;
            II=find(data_mat{uu}(:,5)==8);
            data_mat{uu}(II,5)=-1;
            data_mat{uu}(II,6)=-1;
            II=find(data_mat{uu}(:,5)==11);
            data_mat{uu}(II,5)=-1;
            data_mat{uu}(II,6)=-1;
            II=find(data_mat{uu}(:,5)==12);
            data_mat{uu}(II,5)=-1;
            data_mat{uu}(II,6)=-1;
        end
    elseif behav.hc==5
        keyboard;
    end
    % setup a save file
    L=length(data); save_data=data; save_data_RT=data;
    for ii=1:length(M_headers), 
        save_data{L+ii}.header=M_headers{ii}; 
        save_data_RT{L+ii}.header=M_headers{ii}; 
    end
    for jj=1:ML, 
        save_data{L+jj}.col=nan(N,1); 
        save_data_RT{L+jj}.col=nan(N,1); 
    end; 
    M=nan(N,ML); M_RT=nan(size(M));
    
    for jj=1:N
        [~,E_idx]=ismember(code_mat(jj,:),data_mat{Ef_idx}(:,2:3),'rows');
        if ~isempty(data_mat{R1f_idx})
            [~,R1_idx]=ismember(code_mat(jj,:),data_mat{R1f_idx}(:,2:3),'rows');
            [~,R2_idx]=ismember(code_mat(jj,:),data_mat{R2f_idx}(:,2:3),'rows');
        else
            R1_idx=0; R2_idx=0; % Just says Ret unrun as of now.
        end
        
        if E_idx~=0
            % Check if subject responded
            M(jj,strcmp('E1_catch_R',M_headers))=~isempty(find(key_catch==data_mat{Ef_idx}(E_idx,b1_idx),1));
            % Check if actual check trial
            if (M(jj,strcmp('E1_catch_R',M_headers))==1 && ans_ctc(jj)==1), 
                M(jj,strcmp('E1_catch_hit',M_headers))=1; 
            else
                M(jj,strcmp('E1_catch_hit',M_headers))=0; 
            end
            % Save RT if available
            if M(jj,strcmp('E1_catch_R',M_headers))==1, 
                M(jj,strcmp('E1_catch_RT',M_headers))=data_mat{Ef_idx}(E_idx,RT_idx); 
            end
            M(jj,strcmp('E_block',M_headers))=data_mat{Ef_idx}(E_idx,block_idx);
        end

        if R1_idx~=0
            R=data_mat{R1f_idx}(R1_idx,b2_idx);
            if (R==0 || R==1) % Response, check for hi 
                M(jj,strcmp('R1_hc',M_headers))=~isempty(find(key_hi==data_mat{R1f_idx}(R1_idx,b1_idx),1));
                M(jj,strcmp('R1_RT',M_headers))=data_mat{R1f_idx}(R1_idx,RT_idx);
            end
            tf=0;
            if (ans_old(jj)==1 && R==key_cor), M(jj,strcmp('R1_hit',M_headers))=1; tf=1; else M(jj,strcmp('R1_hit',M_headers))=0; end
            if (ans_old(jj)==1 && R==key_inc), M(jj,strcmp('R1_miss',M_headers))=1; tf=1; else M(jj,strcmp('R1_miss',M_headers))=0; end
            if (ans_old(jj)==0 && R==key_cor), M(jj,strcmp('R1_cr',M_headers))=1; tf=1; else M(jj,strcmp('R1_cr',M_headers))=0; end
            if (ans_old(jj)==0 && R==key_inc), M(jj,strcmp('R1_fa',M_headers))=1; tf=1; else M(jj,strcmp('R1_fa',M_headers))=0; end
            if tf==0 
                M(jj,strcmp('R1_e',M_headers))=1; 
                M(jj,strcmp('R1_hit',M_headers))=NaN;
                M(jj,strcmp('R1_miss',M_headers))=NaN;
                M(jj,strcmp('R1_cr',M_headers))=NaN;
                M(jj,strcmp('R1_fa',M_headers))=NaN;
            end
        end
        if R2_idx~=0
            R=data_mat{R2f_idx}(R2_idx,b2_idx);
            if (R==0 || R==1) % Response, check for hi 
                M(jj,strcmp('R2_hc',M_headers))=~isempty(find(key_hi==data_mat{R2f_idx}(R2_idx,b1_idx),1));
                M(jj,strcmp('R2_RT',M_headers))=data_mat{R2f_idx}(R2_idx,RT_idx);
            end
            M(jj,strcmp('R2_hit',M_headers))=0; 
            M(jj,strcmp('R2_miss',M_headers))=0; 
            M(jj,strcmp('R2_cr',M_headers))=0; 
            M(jj,strcmp('R2_fa',M_headers))=0; 
            % We're reading from the data file as compared to the master as
            % this has changed between subjects.
            afc_resp=data_mat{R2f_idx}(R2_idx,ans_afc_idx); %ans_afc(jj)
            M(jj,strcmp('R2_s',M_headers))=afc_resp;
            tf=0;
            if ((ans_old(jj)==1 && afc_resp==1) && R==key_cor), M(jj,strcmp('R2_hit',M_headers))=1; tf=1; end % Hit
            if ((ans_old(jj)==1 && afc_resp==0) && R==key_cor), M(jj,strcmp('R2_cr',M_headers))=1; tf=1; end % CR
            if ((ans_old(jj)==1 && afc_resp==1) && R==key_inc), M(jj,strcmp('R2_miss',M_headers))=1; tf=1; end % Miss
            if ((ans_old(jj)==1 && afc_resp==0) && R==key_inc), M(jj,strcmp('R2_fa',M_headers))=1; tf=1; end % FA
            
            if ((ans_old(jj)==0 && afc_resp==1) && R==key_cor), M(jj,strcmp('R2_cr',M_headers))=1; tf=1; end % CR
            if ((ans_old(jj)==0 && afc_resp==0) && R==key_cor), M(jj,strcmp('R2_cr',M_headers))=1; tf=1; end % CR
            if ((ans_old(jj)==0 && afc_resp==1) && R==key_inc), M(jj,strcmp('R2_fa',M_headers))=1; tf=1; end % FA
            if ((ans_old(jj)==0 && afc_resp==0) && R==key_inc), M(jj,strcmp('R2_fa',M_headers))=1; tf=1; end % FA
            if tf==0 
                M(jj,strcmp('R2_e',M_headers))=1; 
                M(jj,strcmp('R2_hit',M_headers))=NaN;
                M(jj,strcmp('R2_miss',M_headers))=NaN;
                M(jj,strcmp('R2_cr',M_headers))=NaN;
                M(jj,strcmp('R2_fa',M_headers))=NaN;
            end
        end
        %=================================================================%
        % Incongruency Check
        %=================================================================%
        try
            R1_old=M(jj,strcmp('R1_hit',M_headers)) || M(jj,strcmp('R1_fa',M_headers));
            R1_new=M(jj,strcmp('R1_miss',M_headers)) || M(jj,strcmp('R1_cr',M_headers));
            R2_old=M(jj,strcmp('R2_hit',M_headers)) || M(jj,strcmp('R2_fa',M_headers));
            R2_new=M(jj,strcmp('R2_miss',M_headers)) || M(jj,strcmp('R2_cr',M_headers));
            M(jj,strcmp('R1R2_ON',M_headers))=(R1_old && R2_new);
            M(jj,strcmp('R1R2_NO',M_headers))=(R1_new && R2_old);
        catch err
            M(jj,strcmp('R1R2_ON',M_headers))=NaN;
            M(jj,strcmp('R1R2_NO',M_headers))=NaN;
        end
    end
    %=====================================================================%
    % Create an RT compatible template as well... it has the exact same
    % format as M, but contains RTs instead
    %=====================================================================%
    RT_idx=~cellfun('isempty',(strfind(M_headers,'RT')));
    E1_idx=setdiff(find(~cellfun('isempty',(strfind(M_headers,'E1')))),find(RT_idx));
    R1_idx=setdiff(find(~cellfun('isempty',(strfind(M_headers,'R1')))),find(RT_idx));
    R2_idx=setdiff(find(~cellfun('isempty',(strfind(M_headers,'R2')))),find(RT_idx));
    
    E1_RTs=M(:,strcmp('E1_catch_RT',M_headers));
    R1_RTs=M(:,strcmp('R1_RT',M_headers));
    R2_RTs=M(:,strcmp('R2_RT',M_headers));
    
    for ii=1:length(E1_idx), M_RT(:,E1_idx(ii))=M(:,E1_idx(ii)).*E1_RTs; end
    for ii=1:length(R1_idx), M_RT(:,R1_idx(ii))=M(:,R1_idx(ii)).*R1_RTs; end
    for ii=1:length(R2_idx), M_RT(:,R2_idx(ii))=M(:,R2_idx(ii)).*R2_RTs; end
    M_RT(M_RT==0)=nan;

    for jj=1:ML, 
        save_data{L+jj}.col=M(:,jj); 
        save_data_RT{L+jj}.col=M_RT(:,jj); 
    end
    %=====================================================================%
    % Short mod to remove catch trials and fix ON of template files
    %=====================================================================%
    % Need to fix .mat and .csv files, lets fix the .mat and use it to
    % update the .csv after
    rm_catch=(M(:,1)+M(:,2))>0;
    rm_columns=[4:8 10:14];
    % 1) gotta kill catch trials
    for ii=rm_columns
        M(rm_catch,ii)=NaN;
    end
    % 2) Then update measures
    R1_hit=M(:,5)==1;
    R1_miss=M(:,6)==1;
    R2_hit=M(:,11)==1;
    R2_miss=M(:,12)==1;
    R2_s=M(:,16)==1;
    M(:,19)=and(and(R1_hit,R2_miss),R2_s);
    M(:,20)=and(and(R1_miss,R2_hit),R2_s);
    M(:,22)=and(and(R1_hit,R2_hit),R2_s);
    M(:,23)=and(and(R1_miss,R2_miss),R2_s);
    % 4) Update save_data
    save_data{19}.col=M(:,5);
    save_data{20}.col=M(:,6);
    save_data{21}.col=M(:,7);
    save_data{22}.col=M(:,8);
    save_data{25}.col=M(:,11);
    save_data{26}.col=M(:,12);
    save_data{27}.col=M(:,13);
    save_data{28}.col=M(:,14);
    save_data{33}.col=M(:,19);
    save_data{34}.col=M(:,20);
    save_data{36}.header='R1R2_OO'; save_data{36}.col=M(:,22);
    save_data{37}.header='R1R2_NN'; save_data{37}.col=M(:,23);
    clear R1_hit R1_miss R2_hit R2_miss R2_s;
    write_struct(save_data,save_name);
    write_struct(save_data_RT,save_name_RT);
    switch behav.hc
        case 0
            save(fullfile(behav.save_dir,'pre',[subj_str behav.subjects{s} '.mat']),'M');
            save(fullfile(behav.save_dir,'pre',[subj_str behav.subjects{s} '_RT.mat']),'M_RT');
        case 1
            save(fullfile(behav.save_dir,'pre_hc',[subj_str behav.subjects{s} '.mat']),'M');
            save(fullfile(behav.save_dir,'pre_hc',[subj_str behav.subjects{s} '_RT.mat']),'M_RT');
        case 2
            save(fullfile(behav.save_dir,'pre_hc_only',[subj_str behav.subjects{s} '.mat']),'M');
            save(fullfile(behav.save_dir,'pre_hc_only',[subj_str behav.subjects{s} '_RT.mat']),'M_RT');    
        case 3
            save(fullfile(behav.save_dir,'pre_hc_toss',[subj_str behav.subjects{s} '.mat']),'M');
            save(fullfile(behav.save_dir,'pre_hc_toss',[subj_str behav.subjects{s} '_RT.mat']),'M_RT');  
    end
    clear save_data save_data_RT  M_RT M data_mat
end






