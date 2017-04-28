% BR Geib 2013
%
% Inputs:
%	struct1      => the 1st structure
%	ind1         => index of 1st structures intersect
%	struct2      => the 2nd structure
%	ind2         => index of the 2nd structures intersect
%	name         => Name of the conjoint
%
% Outputs:
%	merge_struct => merged structres
%
% Assumptions
%	Structures are in the format in which their are two fields, one for
%	the header and one for the col data
%
%  duplicate data DNE
%
function merge_struct=merge_structures(struct1,ind1,struct2,ind2,name)
%=========================================================================%
% Presets
%=========================================================================%
missing_data_str='NoData';
remove_duplicates=0;
debug=0;

struct1=flush_struct(struct1);
struct2=flush_struct(struct2);

% 1) Assume that IDs of some kind are being matched. Because of this, make
% sure that no spaces or empties have been snuck in.
subj1=struct1{ind1}.col;
for i=1:length(subj1), subj1{i}=subj1{i}(~isspace(subj1{i})); end
subj1=subj1(~cellfun('isempty',subj1));

subj2=struct2{ind2}.col;
for i=1:length(subj2), subj2{i}=subj2{i}(~isspace(subj2{i})); end
subj2=subj2(~cellfun('isempty',subj2));

subj=unique(union(subj1,subj2)); % A list of all IDs

% 2) Setup the expected headers and classes
hc=1;
merge_struct{hc}.header=name;
merge_struct{hc}.col=subj;
data_type{hc}=class(merge_struct{1}.col{1});
hc=hc+1;

h1_idx=setdiff(1:length(struct1),ind1);
c=1; for j=h1_idx, h1{c}=struct1{j}.header; c=c+1; end
h2_idx=setdiff(1:length(struct2),ind2);
c=1; for j=h2_idx, h2{c}=struct2{j}.header; c=c+1; end

for j=h1_idx
	merge_struct{hc}.header=struct1{j}.header;
	data_type{hc}=class(struct1{j}.col(1));
	hc=hc+1;
end

for j=h2_idx
	merge_struct{hc}.header=struct2{j}.header;
	data_type{hc}=class(struct2{j}.col(1));
	hc=hc+1;
end
%=========================================================================%
% Filling in merge_struct
%=========================================================================%

for S=1:length(merge_struct{1}.col) % Loop through all the subjects
	ID=merge_struct{1}.col{S};	hc=2;
	dprint([n2sp(S,3) ': Examing: ' ID '\n'],debug);
	dprint(' Col: ',debug); 
	[hc,merge_struct]=append_struct(S,hc,merge_struct,data_type,struct1,ind1,h1_idx,ID,missing_data_str,debug);
	dprint('\n',debug); dprint(' Col: ',debug); 
	[~, merge_struct]=append_struct(S,hc,merge_struct,data_type,struct2,ind2,h2_idx,ID,missing_data_str,debug);
	dprint('\n',debug);
end
%=========================================================================%
% Optional removal of duplicates
%=========================================================================%
if remove_duplicates==1,
	for j=1:length(merge_struct), hed{j}=merge_struct{j}.header; end
	[~,IA,~]=intersect(unique(hed),hed);
	kill_idx=setdiff(1:length(hed),IA);
	r_struct=remove_data(kill_idx,merge_struct,'col');	
end

end
%=========================================================================%
% append_struct
%=========================================================================%
function [hc,merge_struct]=append_struct...
	(S,hc,merge_struct,data_type,data,ind,h_idx,ID,missing_data_str,debug)

	% 1) Check to see if the subject has data in struct1
	s1_idx=find(strcmp(ID,data{ind}.col));
	if length(s1_idx)>1
		fprintf([' Warning: Duplicates of "' ID '" exist, pulling from first index\n']);
		s1_idx=s1_idx(1);
	end
	% 2) if output is discovered then it needs to be consolidated
	if ~isempty(s1_idx)	
		for C=1:length(h_idx)
			dprint([num2str(hc) 'f' num2str(h_idx(C)) ' '],debug); 
			switch data_type{hc}
				case 'char', merge_struct{hc}.col(S)=data{h_idx(C)}.col(s1_idx);
				case 'double', merge_struct{hc}.col(S)=data{h_idx(C)}.col(s1_idx);
				case 'cell', merge_struct{hc}.col{S}=data{h_idx(C)}.col{s1_idx};
			end
			hc=hc+1;
		end
	else
		for C=1:length(h_idx)
			dprint([num2str(hc) 'm' num2str(h_idx(C)) ' '],debug); 
			switch data_type{hc}
				case 'char', merge_struct{hc}.col(S)=missing_data_str;
				case 'double', merge_struct{hc}.col(S)=missing_data_str;
				case 'cell', merge_struct{hc}.col{S}=missing_data_str;
			end
			hc=hc+1;
		end
	end

end