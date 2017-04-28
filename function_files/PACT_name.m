% BR Geib 2012
% PACT name conversion
%
% inputs
%   name:
%   convert_to: ucsf, davis, ep, um

function convert_name=PACT_name(name,convert_to)

% Step 1) Determine type
Davis=~isempty(findstr('JAX_',name));
UCSF=strcmp(name(1),'S');
% Step 2) QA check to verify type


switch convert_to
    case 'd2d'
        ind1=findstr('_',name);
        convert_name=name(1:ind1+2,ind1+6:end);
    case 'd2s'
        if UCSF==1, convert_name=name; return; end
        % Pull uni
        uni=name(1);
        switch uni
            case 'd', uni_save='2';
            case 's', uni_save='1';
        end
        % Pull group
        group=name(6);
        switch group
            case '1', group_name='1'; loc='c';
            case '2', group_name='3'; loc='r';
            case '3', group_name='4'; loc='p';
        end
        % Pull ID
        ind1=findstr(loc,name)+1;
        ind2=findstr('_',name(6:end))+4;
        if isempty(ind2)
            ID=name(ind1:end);
        else
            ID=name(ind1:ind2);
        end
        % Pull time
        if ~isempty(ind2)
            switch name(ind2+2:end)
                case '16w', time_suf='b'; 
                case '6m',  time_suf='c'; 
                case '12m', time_suf='d';
            end
        else
            time_suf='a';
        end
        convert_name=['S' uni_save group_name ID time_suf];
        
    case 's2d'
        if Davis==1, convert_name=name; return; end
        % Pull uni
        uni=name(2);
        switch uni
            case '1'
                uni_save='s';
            case '2'
                uni_save='d';
        end
        % Pull group
        group=name(3);
        switch group
            case '1'
                group_save='1'; group_ID='epc';
            case '3'
                group_save='3'; group_ID='urh';
            case '4'
                group_save='4'; group_ID='epp';
			  otherwise
				  fprintf('Bad ID: Error\n'); return;
        end
        % Pull ID
        ID=name(4:6);
        % Pull time
        time_suf='';
%         if length(name)>6
%             time=name(7:end);
%             switch time(1)
%                 case 'b'
%                     time_suf='_16w';
%                 case 'c'
%                     time_suf='_6m';
%             end
%             if length(time)>1
%                 time_suf=[time_suf '_' time(end)];
%             end
%         end
        convert_name=[uni_save 'JAX_' group_save uni_save ID time_suf];
end

