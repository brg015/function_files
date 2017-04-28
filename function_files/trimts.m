function [y,ntrimmed] = trimts(y,sd)
% function [y,ntrimmed] = trimts(y,sd)
% y =  one D vector of data 
% sd = number of std - values out of this range are to be replaced
% ntrimmed = number of values replaced
ntrimmed = 0;
idx = find(abs(y) > sd*std(y));
if ~isempty(idx),
  y(idx) = sign(y(idx)) * sd*std(y);
  ntrimmed = length(idx);
end
end