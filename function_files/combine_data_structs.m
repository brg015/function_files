% B.R. Geib Winter 2012
%
% Works to combine data structures based upon similiar headers, nonsimiliar 
% headers columns are filled with {}, used with cell structures only.
%
function d1=combine_data_structs(d1,d2)

for i=1:length(d1), h1{i}=d1{i}.header; end
for i=1:length(d2), h2{i}=d2{i}.header; end

hu=unique([h1,h2]);
d1=scanner(d1,h1,hu); for i=1:length(d1), h1{i}=d1{i}.header; end
d2=scanner(d2,h2,hu); for i=1:length(d2), h2{i}=d2{i}.header; end

% At this point the structures have the same headers and can be combined
N1=length(d1{1}.col);
N2=length(d2{1}.col);
for i=1:length(h1)
    [garbage,index]=find(strcmp(h1{i},h2));
    d1{i}.col(N1+1:N1+N2)=d2{index}.col(1:N2);
end

end

function data=scanner(data,data_header,header)

c=1;
% Look at the unique headers
hu=setdiff(header,data_header);
for i=1:length(hu)
    data{length(data)+c}.header=hu{i};
    % Add fill it with empties
    data{length(data)}.col(1:length(data{1}.col))={''};
    c=c+1;  
end

end


    