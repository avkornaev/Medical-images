clear
close all
clc
%

%% 1. Settings
cd 

%Dataset
load('dataset.mat')

imsize=[224 224 3];

%The LSTM network depth
depth=10;

%Training
trainAlgorithm = 'adam';% 'sgdm', 'adam'
InitLearnRate = 2e-4;
MaxEp = 10000;
MiniBatchS = nD*8;
GradientThres=2;
validationFrequency = floor(length(targetsTrain)/MiniBatchS);


%The rest
numObservations=4;
netType='LSTM';% 'proposedNet', 'resNet', 'AlexNet','LSTM'

%% Filter targets
nstart=500;
LF=2^8-1;
fs=fps;%approximate frequency of measurements
[f1,A1]=AmpFreqResp(targetsTrain(nstart:nstart+LF),fs,LF);
A1(1)=[];%cut the head values
f1(1)=[];%cut the head values
figure
plot(f1,A1)


%Reserve copy
inputsTrain0=inputsTrain;
inputsValidation0=inputsValidation;
inputsTest0=inputsTest;
targetsTrain0=targetsTrain;
targetsValidation0=targetsValidation;
targetsTest0=targetsTest;

figure ('Color','w')
plot(tTrain,targetsTrain0,'.r',...
     tValidation,targetsValidation,'.g',...
     tTest,targetsTest,'.b')
legend('train','validation','test')
grid on
xlabel ('Time, s')
ylabel ('Velocity, mm/s')

%The low pass filrer application
fpass=3;%Hz
targetsTrain=lowpass(targetsTrain,fpass,fs);
targetsValidation=lowpass(targetsValidation,fpass,fs);
targetsTest=lowpass(targetsTest,fpass,fs);


figure
plot(tTrain,targetsTrain0,'.r',tTrain,targetsTrain,'-b')

%% Merge the train and the validation sets
trainRatio=0.7;
[inputsTrain,targetsTrain,inputsValidation,targetsValidation] =...
    mergeData(inputsTrain,targetsTrain,...
    inputsValidation,targetsValidation,trainRatio);

%% 3. Create the net
switch netType
    case 'proposedNet'
        [layers] = proposedNet(imsize,numClasses)
        analyzeNetwork(layers)
    case 'AlexNet'
        [layers] = alexnetplus(imsize)
        analyzeNetwork(layers)    
    case 'resNet'
        [lgraph] = resnet18plus(imsize,numClasses,paramsDir);
        analyzeNetwork(lgraph)
    case 'LSTM'
        %Reorganize the dataset
%         [inputsTrain]=reorganizeDatasetForLSTM(inputsTrain);
%         [inputsValidation]=reorganizeDatasetForLSTM(inputsValidation);
%         [inputsTest]=reorganizeDatasetForLSTM(inputsTest);
        numFeatures = size(inputsTrain{1},1);
        %numClasses = numel(categories(targetsTrain));
        numClasses=1;
        [layers] = LSTMplus(numFeatures,depth);
         analyzeNetwork(layers)
        
end

%% 5. Train the net
switch netType
    case 'proposedNet'
        opts = trainingOptions(trainAlgorithm, ...
            'InitialLearnRate',InitLearnRate, ...
            'MaxEpochs',MaxEp, ...
            'MiniBatchSize',MiniBatchS,...
            'ValidationData',{inputsValidation,targetsValidation}, ...
            'Verbose',true, ...
            'Plots','training-progress');
        net = trainNetwork(inputsTrain,targetsTrain,layers,opts);
    case 'AlexNet'
        opts = trainingOptions(trainAlgorithm, ...
            'InitialLearnRate',InitLearnRate, ...
            'MaxEpochs',MaxEp, ...
            'MiniBatchSize',MiniBatchS,...
            'ValidationData',{inputsValidation,targetsValidation}, ...
            'Verbose',true, ...
            'Plots','training-progress');
        net = trainNetwork(inputsTrain,targetsTrain,layers,opts)        
    case 'resNet'
        opts = trainingOptions(trainAlgorithm, ...
            'InitialLearnRate',InitLearnRate, ...
            'MaxEpochs',MaxEp, ...
            'MiniBatchSize',MiniBatchS,...
            'ValidationData',{inputsValidation,targetsValidation}, ...
            'Verbose',true, ...
            'Plots','training-progress');
        net = trainNetwork(inputsTrain,targetsTrain,lgraph,opts)
    case 'LSTM'
                opts = trainingOptions(trainAlgorithm, ...
            'InitialLearnRate',InitLearnRate, ...
            'GradientThreshold',GradientThres, ...
            'MaxEpochs',MaxEp, ...
            'MiniBatchSize',MiniBatchS,...
            'ValidationData',{inputsValidation,targetsValidation}, ...
            'Verbose',true, ...
            'Plots','training-progress');
        %net = trainNetwork([inputsTrain;inputsTest],[targetsTrain;targetsTest],layers,opts)
        net = trainNetwork(inputsTrain,targetsTrain,layers,opts)
end

%% 7. Check the trained net using all images in the Test folder

% Enter your code here
%
%     Create datastore of images from the Test folder
%     Segment all the images using the trained net
%     Save segmented images in a new folder
%

targetsPredTest=predict(net,inputsTest0);
error=(targetsTest-targetsPredTest)./targetsTest;
meanPredTest=mean(targetsPredTest)
meanTest=mean(targetsTest0)
accurMeanTest=1-abs((meanPredTest-meanTest)/meanTest)
figure
plot(tTest,targetsPredTest,'-b',tTest,targetsTest0,':k')
title("Test set")
 
targetsPredTrain=predict(net,inputsTrain0);
meanPredTrain=mean(targetsPredTrain)
meanTrain=mean(targetsTrain0)
accurMeanTrain=1-abs((meanPredTrain-meanTrain)/meanTrain)
figure
plot(tTrain,targetsPredTrain,'-b',tTrain,targetsTrain0,'.b')
title("Train set")

targetsPredValidation=predict(net,inputsValidation0);
meanPredValidation=mean(targetsPredValidation)
meanValidation=mean(targetsValidation0)
accurMeanValidation=1-abs((meanPredValidation-meanValidation)/meanValidation)
figure
plot(tValidation,targetsPredValidation,'-b',tValidation,targetsValidation0,'.b')
title("Validation set")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure ('Color','w')
plot(tTrain,targetsPredTrain,'-k',tTrain,lowpass(targetsTrain0,fpass,fs),':r',...
     tValidation,targetsPredValidation,'-k',tValidation,lowpass(targetsValidation0,fpass,fs),':g',...
     tTest,targetsPredTest,'-k',tTest,lowpass(targetsTest0,fpass,fs),':b')
%legend('train','validation','test')
grid on
xlabel ('Time, s')
ylabel ('Velocity, mm/s')



