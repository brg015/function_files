function d=dprime_calc(vHits,vFa)

pHit=sum(vHits)/(sum(vHits)+sum(vFa));
if pHit==0,
    pHit=0.5/(sum(vHits)+sum(vFa));
elseif pHit==1
    pHit=(sum(vHits)-0.5)/(sum(vFa)+sum(vFa));
end

pFA=sum(vFa)/(sum(vHits)+sum(vFa));
if pFA==0,
    pFA=0.5/(sum(vHits)+sum(vFa));
elseif pFA==1
    pFA=(sum(vFa)-0.5)/(sum(vHits)+sum(vFa));
end

%-- Convert to Z scores, no error checking
zHit = norminv(pHit) ;
zFA  = norminv(pFA) ;

%-- Calculate d-prime
d = zHit - zFA ;