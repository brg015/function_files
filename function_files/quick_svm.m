function [ACC,Label,Like]=quick_svm(data,labels)

SVMModel=fitcsvm(data,labels,'KernelFunction','linear',...
    'Standardize',true,'Leaveout','on');
[Label,OOSPostProbs] = kfoldPredict(SVMModel);
ACC=mean(Label==labels);
Like=abs(OOSPostProbs(:,1));
