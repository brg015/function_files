function compile_behave(behave)
%=========================================================================%
% Preset the collection
%=========================================================================%
N=1;

scenario='natural';
switch scenario
    case 'natural'
        for ii=1:2
            switch ii
                case 1, hp='LC_';     fp='';
                case 2, hp='HC_';     fp='_hc';
                case 3, hp='HC_only_'; fp='_hc_only';
                case 4, hp='HC_toss_'; fp='_hc_toss';
                case 5, hp='LC_only_'; fp='_lc_only';
            end
            f{N}=fullfile(behave.save_dir,['pro' fp],'base','Nevents_summary.csv');
            get{N}={'ID' 'R1R2_OO' 'R1R2_NN' 'R1R2_ON' 'R1R2_NO'};
            idx{N}={[hp 'Subject'] [hp 'HH'] [hp 'MM'] [hp 'HM'] [hp 'MH']};
            N=N+1; 

            f{N}=fullfile(behave.save_dir,['pro' fp],'base','dprime.csv');
            get{N}={'Word' 'Picture'};
            idx{N}={[hp 'Word'] [hp 'Picture']};
            N=N+1;  

            f{N}=fullfile(behave.save_dir,['pro' fp],'base','Nevents_summary.csv');
            get{N}={'E1_catch_R' 'E1_catch_hit'};
            idx{N}={[hp 'E_R'] [hp 'E_H']};
            N=N+1;   

            f{N}=fullfile(behave.save_dir,['pro' fp],'base','Nevents_summary.csv');
            get{N}={'R1_e' 'R2_e'};
            idx{N}={[hp 'R1_e'] [hp 'R2_e']};
            N=N+1;   

            f{N}=fullfile(behave.save_dir,['pro' fp],'base','Nevents_summary.csv');
            get{N}={'R1_hit' 'R1_miss' 'R1_cr' 'R1_fa' 'R2_hit' 'R2_miss' 'R2_cr' 'R2_fa'};
            idx{N}={[hp 'R1_hit_N'] [hp 'R1_miss_N'] [hp 'R1_cr_N'] [hp 'R1_fa_N'] ...
                [hp 'R2_hit_N'] [hp 'R2_miss_N'] [hp 'R2_cr_N'] [hp 'R2_fa_N']};
            N=N+1;  

            f{N}=fullfile(behave.save_dir,['pro' fp],'base','mean_summary.csv');
            get{N}={'R1_hit' 'R1_miss' 'R1_cr' 'R1_fa' 'R2_hit' 'R2_miss' 'R2_cr' 'R2_fa'};
            idx{N}={[hp 'R1_hit_p'] [hp 'R1_miss_p'] [hp 'R1_cr_p'] [hp 'R1_fa_p'] ...
                [hp 'R2_hit_p'] [hp 'R2_miss_p'] [hp 'R2_cr_p'] [hp 'R2_fa_p']};
            N=N+1;  

%             f{N}=fullfile(behave.save_dir,['pro' fp],'base','mean_RT_summary.csv');
%             get{N}={'R1_hit' 'R1_miss' 'R1_cr' 'R1_fa' 'R2_hit' 'R2_miss' 'R2_cr' 'R2_fa'};
%             idx{N}={[hp 'R1_hit_RT'] [hp 'R1_miss_RT'] [hp 'R1_cr_RT'] [hp 'R1_fa_RT'] ...
%                 [hp 'R2_hit_RT'] [hp 'R2_miss_RT'] [hp 'R2_cr_RT'] [hp 'R2_fa_RT']};
%             N=N+1;  
        end
    case 'category'
        fp='_hc';
        category={'birds' 'building' 'clothing' 'food' 'fruit' 'furniture' ...
            'mammal' 'musical instruments' 'street items' 'tool' 'vegetable' ...
            'vehicle'};
        for ii=1:length(category),
            f{N}=fullfile(behave.save_dir,['pro' fp],'base',[category{ii} 'Nevents_summary.csv']);
            get{N}={'R1_hit' 'R1_miss' 'R1_cr' 'R1_fa' 'R2_hit' 'R2_miss' 'R2_cr' 'R2_fa' 'R1R2_OO' 'R1R2_NN' 'R1R2_ON' 'R1R2_NO'};
            idx{N}={[category{ii} 'R1_hit'] [category{ii} 'R1_miss'] [category{ii} 'R1_cr'] [category{ii} 'R1_fa'] ...
                [category{ii} 'R2_hit'] [category{ii} 'R2_miss'] [category{ii} 'R2_cr'] [category{ii} 'R2_fa'] ...
                [category{ii} 'R1R2_OO'] [category{ii} 'R1R2_NN'] [category{ii} 'R1R2_ON'] [category{ii} 'R1R2_NO']};
            N=N+1; 
        end          
end

c=1;
for ii=1:N-1
    for jj=1:length(idx{ii})
        shead{c}=idx{ii}{jj}; c=c+1;
    end
end

for ii=1:length(shead), data{ii}.header=shead{ii}; end


%=========================================================================%
% Collect those measures
%=========================================================================%
for ii=1:length(f)
    tdata=excel_reader(f{ii});
    head=gethead(tdata);
    for jj=1:length(get{ii})
        ti1=strcmp(head,get{ii}{jj});
        ti2=strcmp(shead,idx{ii}{jj});
        try
            data{ti2}.col=tdata{ti1}.col;
        catch err
            keyboard
        end
        clear ti1 ti2
    end
    clear tdata head 
end
write_struct(data,fullfile(behave.save_dir,[scenario '_compiled_data.csv']));

        
        
        