%% start demo
clear;
close all;
addpath(genpath('.\L1General'));

%% load data
load('.\R codes\surv_os_ovary_rank_ci.mat')
dat = struct2cell(dat);
days = struct2cell(days);
status = struct2cell(status);
pvalues = struct2cell(pvalues);

%% leave-one-dataset-out testing
for whichtest = 1:length(dat)
    % get training data
    Xtrain = dat; Xtrain(whichtest)=[];
    ytrain = days; ytrain(whichtest)=[];
    ctrain = status; ctrain(whichtest)=[];
    % get testing data
    Xtest = dat{whichtest};
    ytest = days{whichtest};
    ctest = status{whichtest};
    % use the significant genes in the model
    idx_keep = find(mafdr(pvalues{whichtest},'BHFDR',true)<0.05);
    for i = 1:length(Xtrain)
        Xtrain{i} = Xtrain{i}(:,idx_keep);
    end
    Xtest = Xtest(:,idx_keep);
    % train model
    b_est = cvMeta(Xtrain,ytrain,ctrain,0);
    % test performance
    scoretest=Xtest*b_est;
    disp(['concordance index on test dataset ',num2str(whichtest),' is: ',num2str(CIndex(ytest,ctest,scoretest))]);
end
