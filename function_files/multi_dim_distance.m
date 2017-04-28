% Function file
% BR Geib 2013
%
% Description: This script accepts two vectors and procedes to calculate
% the euclidian distance between them
function d=multi_dim_distance(A,B)

for i=1:length(A), t(i)=(A(i)-B(i))^2; end
d=sqrt(sum(t));