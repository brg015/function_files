function SL_hemi_mode(cursub)
global SL;
jb=[0 cumsum(SL.design.Box)];
%-------------------------------Micro-------------------------------------%
% Add in some behave details
bdir1=[SL.root_dir 'fmri_reanalysis\hemi\young\data\behav\'];
bdir2=[SL.root_dir 'fmri_reanalysis\hemi\old\data\behav\'];
ID=SL.dir.subjects{cursub};

% sfile=fullfile(SL.dir.stpath,ID,'behav_norms.mat');
f1=dir(fullfile(bdir1,ID,'*xl*'));
f2=dir(fullfile(bdir2,ID,'*xl*'));
if ~isempty(f1), 
    lf=fullfile(bdir1,ID,f1(1).name); 
else
    lf=fullfile(bdir2,ID,f2(1).name);
end

D=ReadFromExcel(lf, 'ALL');
T_RN=D(2:end,35);
T_ID=D(2:end,36);
C_ID=D(2:end,39);
% language params
L_FQ=D(2:end,56);
L_NM=D(2:end,57);
W_LS=D(2:end,43); % List pull

W_44=D(2:end,44); % Word pull
for ii=1:length(T_ID)
    try, T_IDn(ii)=T_ID{ii}; catch err, T_IDn(ii)=NaN; end
    try, C_IDn(ii)=str2num(C_ID{ii}(end)); catch err, C_IDn(ii)=NaN; end
    try, T_RNn(ii)=T_RN{ii}+1; catch err, T_RNn(ii)=NaN; end
    try, L_FQn(ii)=L_FQ{ii}; catch err, L_FQn(ii)=NaN; end
    try, L_NMn(ii)=L_NM{ii}; catch err, L_NMn(ii)=NaN; end
    try, W_LSn(ii)=W_LS{ii}; catch err, W_LSn(ii)=NaN; end
end
% Pull out RUN and TRIAL IDs from Vbeta settings
for jj=1:2
    switch jj
        case 1, s1='_Run'; s2='_Tri';
        case 2, s1='_Tri'; s2='phase';
    end

    for ii=1:length(SL.design.ID_descrip)
        i1=findstr(s1,SL.design.ID_descrip{ii});
        i2=findstr(s2,SL.design.ID_descrip{ii});
        I{jj}(ii)=str2num(SL.design.ID_descrip{ii}(i1+length(s1):i2-1));
    end
end

% finally pull in those confidence measures.
SL.design.ID_conf=[];
SL.design.lang_norm=[];
SL.design.lang_freq=[];
SL.design.word_match={};
SL.design.list=[];
for ii=1:length(SL.design.ID_descrip)
    % only one unique should exist
    i1=and(T_RNn==I{1}(ii),T_IDn==I{2}(ii));
    try
        SL.design.ID_conf(ii)=C_IDn(i1);
        SL.design.lang_norm(ii)=L_NMn(i1);
        SL.design.lang_freq(ii)=L_FQn(i1);
        SL.design.word_match{ii}=W_44{i1};
        SL.design.list(ii)=W_LSn(i1);
    end
end

if ~strcmp(SL.Hemi_set.model,'Memory'), 
    display('Jumping out of SL_hemi_mode early');
    return; 
end

HC=or(SL.design.ID_conf==1,SL.design.ID_conf==4);
LC=or(SL.design.ID_conf==2,SL.design.ID_conf==3);
HCK=zeros(jb(end),jb(end)); HCK(HC,:)=1;
LCK=zeros(jb(end),jb(end)); LCK(LC,:)=1;
clear i1 i2 I T_* C_* D ID f1 f2;

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

% Changed post SfN to only include rows here, still want comparisons to
% everything else being possible.
I1=SL.design.hemi_trial_counts_cfmh(:,2)==2;
I2=SL.design.hemi_trial_counts_cfmh(:,2)==0;
KF(I1,:)=1;
KC(I2,:)=1;

ii=5;
SL.design.anova{ii}.f{1}=SL.design.anova{ii}.f{1}.*KC;
SL.design.anova{ii}.f{2}=SL.design.anova{ii}.f{2}.*KC;
ii=6;
SL.design.anova{ii}.f{1}=SL.design.anova{ii}.f{1}.*KF;
SL.design.anova{ii}.f{2}=SL.design.anova{ii}.f{2}.*KF;

ii=7;
SL.design.anova{ii}.f{1}=SL.design.anova{ii}.f{1}.*HCK;
SL.design.anova{ii}.f{2}=SL.design.anova{ii}.f{2}.*HCK;
ii=8;
SL.design.anova{ii}.f{1}=SL.design.anova{ii}.f{1}.*HCK;
SL.design.anova{ii}.f{2}=SL.design.anova{ii}.f{2}.*HCK;
ii=9;
SL.design.anova{ii}.f{1}=SL.design.anova{ii}.f{1}.*HCK;
SL.design.anova{ii}.f{2}=SL.design.anova{ii}.f{2}.*HCK;
ii=10;
SL.design.anova{ii}.f{1}=SL.design.anova{ii}.f{1}.*HCK;
SL.design.anova{ii}.f{2}=SL.design.anova{ii}.f{2}.*HCK;

ii=11;
SL.design.anova{ii}.f{1}=SL.design.anova{ii}.f{1}.*LCK;
SL.design.anova{ii}.f{2}=SL.design.anova{ii}.f{2}.*LCK;
ii=12;
SL.design.anova{ii}.f{1}=SL.design.anova{ii}.f{1}.*LCK;
SL.design.anova{ii}.f{2}=SL.design.anova{ii}.f{2}.*LCK;
ii=13;
SL.design.anova{ii}.f{1}=SL.design.anova{ii}.f{1}.*LCK;
SL.design.anova{ii}.f{2}=SL.design.anova{ii}.f{2}.*LCK;
ii=14;
SL.design.anova{ii}.f{1}=SL.design.anova{ii}.f{1}.*LCK;
SL.design.anova{ii}.f{2}=SL.design.anova{ii}.f{2}.*LCK;
