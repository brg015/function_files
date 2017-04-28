function [C1,C2,C_var,dis]=pca_shell(Xvarin,var_label,subj_label,Yvar,s)
%
var_expl=95;
M={'s' 'o' '*' '.'}; C={'b' 'r' 'g' 'k'};
distr='binomial';
dis=[];

z=1;
% Median split (hi/lo memory here)
lomem=find(Yvar<=median(Yvar));
himem=find(Yvar>median(Yvar));
switch distr
    case 'binomial', Yvar(lomem)=0; Yvar(himem)=1;
    case 'poisson',
    case 'gamma'
end
if z==1
    Xvarin=zscore(Xvarin')';
end
[coeff,score,latent,tsqr,expl,mu]=pca(Xvarin');
expl95=find(cumsum(expl)>var_expl,1);
if expl95<2, expl95=2; end
mdl=fitglm(score(:,1:expl95),Yvar','distribution',distr)
mdl.ModelCriterion

[~,t2]=sort(abs(mdl.Coefficients.tStat(2:end)));
C1=t2(end); C2=t2(end-1); C3=t2(end-2); clear t2; 
C_var=sum(expl([C1,C2]));
% Based upon most important componetns, make some graphs
% mw=repmat(mean(Xvarin,2),[1,size(score,2)]);
T=score; P=coeff; dx=0; dy=0;

figure(1);
for ii=1:length(s)
    plot(P(s{ii},C1),P(s{ii},C2),M{ii},'color',C{ii},'markerfacecolor',C{ii},'markersize',8); hold on;
end
text(P(:,C1)+dx,P(:,C2)+dy,var_label,'FontSize',14,'rotation',30); grid;
xlabel(['Component ' num2str(C1)]);
ylabel(['Component ' num2str(C2)]);
% Sit together indicates similar beahvior between observations

figure(2);
s2{1}=lomem; s2{2}=himem;
for ii=1:2
    plot(T(s2{ii},C1),T(s2{ii},C2),M{ii},'color',C{ii},...
        'markerfacecolor',C{ii},'markersize',8); hold on;
end
text(T(:,C1)+dx,T(:,C2)+dy,subj_label,'FontSize',10,'rotation',20); grid;
xlabel(['Component ' num2str(C1)]);
ylabel(['Component ' num2str(C2)]);

% Sit together indicates similar behavior between subjects
figure(3);
biplot(coeff(:,[C1,C2]),'scores',score(:,[C1,C2]),'varlabels',var_label);
xlabel(['Component ' num2str(C1)]);
ylabel(['Component ' num2str(C2)]);

% figure(6);
% pareto(expl); xlabel('Principal Component'); ylabel('Variance Explained');
mdl=fitglm(score(:,[C1,C2]),Yvar','distribution',distr)


% [v,index]=sort(sqrt(P(s{ii},C1).^2+P(s{ii},C2).^2),'descend');
% vl=var_label(s{1});
% figure(4); x=(1:length(v));
% plot(x,v,M{ii},'color',C{ii},'markerfacecolor',C{ii},'markersize',8); hold on;
% text(x,v,vl(index),'FontSize',14,'rotation',30); 
% ylabel('distance from centroid');
% grid;
% dis.val=v;
% dis.lbl=vl(index);





