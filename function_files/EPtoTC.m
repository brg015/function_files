% Function file
%
% Description: Converts EP to TC IDs
%
% Inputs:
%	ID = XXX## or XXX###
%	timepoint = 00_MONTH/ etc.

function TC=EPtoTC(ID,timepoint)
	month=timepoint(1:2);
	group=ID(3);
	switch length(ID)
		case 5, number=['0' ID(4:end)];
		case 6, number=ID(5:end);
		% For UHR converters
		case 10, number=['0' ID(4:end)];
		case 11, number=[ID(4:end)];
	end
	TC=[group number '_' month];
end