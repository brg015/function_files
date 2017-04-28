function I=nanand(I1,I2)

i1=isnan(I1);
i2=isnan(I2);
i3=(i1 | i2);

I1(isnan(I1))=0;
I2(isnan(I2))=0;

I=and(I1,I2);
I(i3)=0;