function write_vbeta(subject,QA_dir)
global SL;

for ii=1:length(SL.design.Box)
    data_vbeta{(ii-1)*2+1}.header=SL.design.cond_str{ii}{1};
    data_vbeta{(ii-1)*2+2}.header='ID';
    for jj=2:length(SL.design.cond_str{ii}),
        data_vbeta{(ii-1)*2+1}.header=[data_vbeta{(ii-1)*2+1}.header '_' SL.design.cond_str{ii}{jj}];
    end     
end
display('--SPM information--'); c=1;
for ii=1:length(SL.design.Box)
    fprintf(['Condition: ' num2str(ii) '\n']); 
    for jj=1:SL.design.Box(ii);
       display([' I' n2sp(SL.design.ID_idx(c),3) ' : ', ...
       SL.design.ID_descrip{c}]); 
       data_vbeta{(ii-1)*2+1}.col{jj}=SL.design.ID_descrip{c}; 
       data_vbeta{(ii-1)*2+2}.col{jj}=SL.design.ID_idx(c); 
       c=c+1;
    end
end
write_struct(data_vbeta,fullfile(QA_dir,['vbeta.csv']));    
clear data_vbeta;

if SL.regress.on==1
    L=length(SL.regress.str)+1;
    for ii=1:length(SL.design.Box)
        data_vbeta{(ii-1)*L+1}.header=SL.design.cond_str{ii}{1};
        for jj=1:(L-1)
            data_vbeta{(ii-1)*L+1+jj}.header=SL.regress.name{jj};
        end
        for jj=2:length(SL.design.cond_str{ii}),
            data_vbeta{(ii-1)*L+1}.header=[data_vbeta{(ii-1)*L+1}.header '_' SL.design.cond_str{ii}{jj}];
        end     
    end
    c=1;
    for ii=1:length(SL.design.Box)
        fprintf(['Condition: ' num2str(ii) '\n']); 
        for jj=1:SL.design.Box(ii);
           data_vbeta{(ii-1)*L+1}.col{jj}=SL.design.ID_descrip{c}; 
           for kk=1:(L-1)
               data_vbeta{(ii-1)*L+1+kk}.col{jj}=SL.regress.val(c,kk); 
           end
           c=c+1;
        end
    end
    write_struct(data_vbeta,fullfile(QA_dir,[subject '_regress.csv']));    
end
    
    