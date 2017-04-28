% Function: win_print(str)
% BRG Winter 2014
%
% Description: The function accepts a string, recognizes \t and \n
% characters and prints output to screen while allowing the display of \
% characters typical to windows paths.
% function win_print(str)
%
% Notes: Could be better written in the future, but don't think that'll
% slow things down all that much. And it unfortunatley fudges pathways that
% begin with an n or t as it flags these as escapes...
function win_print(str)

escp_n=strfind(str,'\n');
escp_t=strfind(str,'\t'); 
[~,path_ind]=setdiff(1:length(str),union([escp_n escp_n+1],[escp_t escp_t+1]));
path_str=str(path_ind); 
if ~isempty(path_ind), path_ind=path_ind(1); end

disp_pre=0; %disp outputs return, thus \n after disp can be disregarded
for ii=sort([escp_n,escp_t,path_ind])
    if (~isempty(find(escp_n==ii, 1)) && disp_pre==0), fprintf('\n'); disp_pre=0; end
    if ~isempty(find(escp_t==ii, 1)), fprintf('\t'); disp_pre=0; end
    if ~isempty(find(path_ind==ii, 1)), disp(path_str); disp_pre=1; end
end



