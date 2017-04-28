% BRG Summer 2014
% function_file
%
% Description: Accepts a cell array of numeric strings as input and returns
% the numeric array as doublees.
function num_array=cell2num(cell_array,varargin)

if ~iscell(cell_array), num_array=cell_array; return; end
    
num_array=nan(1,length(cell_array));
for ii=1:length(cell_array), 
    try
        num_array(ii)=str2double(cell_array{ii}); 
    catch err
        num_array(ii)=nan;
    end
end
    
if exist('varargin','var')
    num_array(isnan(num_array))=0;
end

