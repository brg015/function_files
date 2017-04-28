function X=write_csv(M,header,file_name)

for ii=1:size(M,2)
    X{ii}.header=header{ii};
    X{ii}.col=M(:,ii);
end

write_struct(X,file_name);

