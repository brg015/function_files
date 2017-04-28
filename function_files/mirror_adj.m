function R=mirror_adj(R)
% sets i,j == j,i without loops
n=size(R);
[i,j]=find(tril(ones(n),-1));
ind1=sub2ind(n,j,i); ind2=sub2ind(n,i,j);
R(ind1)=R(ind2);