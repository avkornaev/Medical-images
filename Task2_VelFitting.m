  
%% Task 2: Velocity fitting uning an ANN


%% Initialization and settings
clear ; close all; clc

%Settings, including net.trainParam

hiddenLayersSizes = [10];%sizes of hidden layers
maxEpochs=500;%maximum number of Epochs
performanceGoal=0;%performance goal
minGrad=1e-7;%minimal value of the gradient 
maxValChecks=1e3;%maxim number of the validation iterations
%divideDataSet=[0.7,0.2,0.1];%training,validation and test subsets
iterations = 3e6;% # of iterations
alpha = 1e-4;% learning rate

%% 1. Dataset
load dataset.mat

%Merge
nTrain=length(targetsTrain);
nValidation=length(targetsValidation);
nTest=length(targetsTest);

nAll=nTrain+nValidation+nTest;

inputs=[inputsTrain; inputsValidation; inputsTest]';
targets=[targetsTrain; targetsValidation; targetsTrain]';

%% 2. The ANN design and tuning

%Create the ANN
net = fitnet(hiddenLayersSizes);
view(net)

% net.divideParam.trainRatio = 1/3;
% net.divideParam.valRatio = 1/3;
% net.divideParam.testRatio = 1/3;

net.divideMode

[trainInd,valInd,testInd] = divideind(nAll,[1:nTrain],[nTrain+1:nValidation],[nValidation+1:nTest]);


%The ANN settings
net.trainParam.epochs = maxEpochs; 
net.trainParam.goal = performanceGoal; 
net.trainParam.max_fail = maxValChecks; 
net.trainParam.min_grad=minGrad;
% net.divideParam.trainRatio = divideDataSet(1);
% net.divideParam.valRatio = divideDataSet(2);
% net.divideParam.testRatio = divideDataSet(3);

%% 3. The ANN training, validation and testing 
[net,tr] = trainlm(net,inputs,targets);
H=net(inputs);%the ANN predictions
figure
plotperform(tr)
%plotconfusion(H,targets)
view(net)
% 
% %% 4. Test the ANN using data from the inputs_val and targets_val subsets
% H=0;
% H=net(inputs_test);%the ANN predictions
% H=round(H);%round to zero or one
% 
% Accuracy=accuracy_calc(net,H,targets_test)
% %You should fix the function bellow
% F1=F_score(net,H,targets_test)