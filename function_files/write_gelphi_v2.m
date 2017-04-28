function write_gelphi_v2(GT,Net)
%=========================================================================%
% R   => ring of node
% d   => distance matrix for nodes
% XYZ => node coordinates

% Write the nodelist first
fid=fopen(GT.save_to,'w+');
%-------------------------------------------------------------------------%
% Define and save the nodal measures
%-------------------------------------------------------------------------%
str='nodedef>';
for ii=1:length(GT.node)
    str=[str GT.node(ii).name ' ' GT.node(ii).class ',']; 
end
str=str(1:end-1);
fprintf(fid,[str '\n']);

I=find(GT.include);
for ii=I
    str=[];
    for jj=1:length(GT.node)
        % Allow for numeric arrays as well
        try
            str=[str GT.node(jj).val{ii} ','];
        catch err
            str=[str num2str(GT.node(jj).val(ii)) ','];
        end
    end
    str=str(1:end-1);
    fprintf(fid,[str '\n']);
end
%-------------------------------------------------------------------------%
% Define edge measures
%-------------------------------------------------------------------------%
str='edgedef>node1 VARCHAR,node2 VARCHAR, weight DOUBLE, dirWeight DOUBLE';
fprintf(fid,[str '\n']);
c=1;

for ii=1:length(Net)
    for jj=1:length(Net)
        if (Net(ii,jj)~=0 && ~isnan(Net(ii,jj)))
           str=['R' num2str(I(ii)) ',R' num2str(I(jj)) ',' num2str(abs(Net(ii,jj))) ,',' num2str(Net(ii,jj))];
           fprintf(fid,[str '\n']);
           V(c)=Net(ii,jj); c=c+1;
        end
    end
end
fclose(fid);
