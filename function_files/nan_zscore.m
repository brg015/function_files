function zvect=nan_zscore(vect)

I=isnan(vect);
v1=vect(~I);
v2=zscore(v1);
zvect=vect;
zvect(~I)=v2;