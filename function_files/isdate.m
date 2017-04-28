function yn=isdate(date_val)
warning off
yn=0;
try
    garbage=datenum(date_val);
    if ~isempty(garbage)
        yn=1;
    end
catch err
end
warning off