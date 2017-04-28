% BRG 2014 Winter
% Function File
% 
% Description: Compares a string with a cell array. If the strings within
% the cell array are also in the string then 1 is returned. If not 0.
function tf=mstrcmp(str,cell_array)

s=find(strcmp('|',cell_array));
if ~isempty(s)
    N=combn([-1 1],length(s)); L=size(N,1);
    for ii=1:L
        exclude=[];
        for jj=1:size(N,2)
            exclude=[exclude s(jj) s(jj)+N(ii,jj)];
        end
        cc{ii}=cell_array(setdiff(1:length(cell_array),exclude));
    end
else
    cc{1}=cell_array; L=1;
end
    
if ~isempty(s), modify=1; else L=1; end

for jj=1:L
    detector=zeros(1,length(cc{jj})); tf(jj)=0;
    for ii=1:length(cc{jj})
        if ~isempty(strfind(str,cc{jj}{ii}))
            detector(ii)=1;
        end
    end
    if isempty(find(detector==0, 1)), tf(jj)=1; end  
end

tf=sum(tf)>0;