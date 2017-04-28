% Function file
% n2sp => Number to String Pad

function str=n2sp(num,pad)

    str=num2str(num);
    while length(str)<pad
        str=['0' str];
    end
