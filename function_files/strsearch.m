% B.R. Geib Fall 2012
% Function File 
% index=strsearch(str,cell_array)
%
% Description: This is a simple script which searches a cell array for a
% string and returns indices of the positon.
%
% Inputs:
%	str        => a str to search for
%	cell_array => a cell arrray
% Outputs:
%	index      => cells which have the specified string
function index=strsearch(str,cell_array)
    index=find(~cellfun('isempty',strfind(cell_array,str)));
end