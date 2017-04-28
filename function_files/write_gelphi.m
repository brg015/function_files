function write_gelphi(T,M,N,save_to)
%------------------%
% ROI Locations AAL
%------------------%
Data=excel_reader('D:\Data\Geib\WFU_ROIs\ROI_locations.csv');
I=zeros(length(N),1);
for ii=1:length(N)
    if sum(strcmp(N{ii},Data{2}.col))>0
        r=strcmp(N{ii},Data{2}.col);
        I(ii)=1;
        X(ii)=str2double(Data{8}.col(r));
        Y(ii)=str2double(Data{9}.col(r));
        Z(ii)=str2double(Data{10}.col(r));
        Name{ii}=Data{4}.col{r};
    end
end

% Distance measures;
for ii=1:length(N)
    for jj=1:length(N)
        d(ii,jj)=sqrt((X(ii)-X(jj)).^2+(Y(ii)-Y(jj)).^2+(Z(ii)-Z(jj)).^2);
    end
end

if ~isempty(T)
    T(T==0)=NaN; R=max(T); clear T; 
else
    R=ones(1,length(N));
end

%=========================================================================%
% R   => ring of node
% d   => distance matrix for nodes
% XYZ => node coordinates

% Write the nodelist first
fid=fopen(save_to,'w+');
%Node define header
str='nodedef>name VARCHAR,label VARCHAR,ring DOUBLE,x DOUBLE,y DOUBLE,z DOUBLE';
fprintf(fid,[str '\n']);
for ii=1:length(N)
    str=['R' num2str(ii) ',' Name{ii} ',' num2str(R(ii)) ',' num2str(X(ii)) ',' num2str(Y(ii)) ',' num2str(Z(ii))];
    fprintf(fid,[str '\n']);
end
str='edgedef>node1 VARCHAR,node2 VARCHAR, weight DOUBLE, distance DOUBLE';
fprintf(fid,[str '\n']);
c=1;
for ii=1:length(M)
    for jj=1:length(M)
        if (M(ii,jj)~=0 && ~isnan(M(ii,jj)))
           str=['R' num2str(ii) ',R' num2str(jj) ',' num2str(M(ii,jj)) ',' num2str(d(ii,jj))];
           fprintf(fid,[str '\n']);
           V(c)=M(ii,jj); c=c+1;
        end
    end
end
fclose(fid);
