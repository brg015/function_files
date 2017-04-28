function I=ER_getID(fname,ID)

load(fname);
strget=['ID' num2str(ID)];
I1=strfind({SPM.Vbeta.descrip},strget);
I2=find(~cellfun('isempty',I1));
I=I2(1);
