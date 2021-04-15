clear
clc
close all

%S

%% 1. Initialisations and Settings
load ('targets.mat')%calculated speed
%c1 is for validation, c2 is for train, and c3 is for test

deltaT=time(2)-time(1);
fps=1/deltaT;

imsize=[224 224];%image size
nD=7;%number of time frames in an input

N = 1500;%No of images or inf

cd 
mDir=cd;%main directory
imdirTrain='imagesTrain';%subdirectory for images
imdirValidation='imagesValidation';
imdirTest='imagesTest';

generateSequenses='yes';%'yes,'no'

%% 2. Create dataset

switch generateSequenses
    case 'yes'
        %netCNN = googlenet;
        netCNN = resnet18;
        imsize = netCNN.Layers(1).InputSize(1:2);
        %layerName = "pool5-7x7_s1";
        layerName = "pool5";
        [inputsTrain,targetsTrain,tTrain]=...
            sequenceDatasetGenerator(netCNN,layerName,imdirTrain,mDir,...
            deltaT,nD,c2,N);
        [inputsValidation,targetsValidation,tValidation]=...
            sequenceDatasetGenerator(netCNN,layerName,imdirValidation,mDir,...
            deltaT,nD,c1,N);
        [inputsTest,targetsTest,tTest]=...
            sequenceDatasetGenerator(netCNN,layerName,imdirTest,mDir,...
            deltaT,nD,c3,N);       
        
%         [inputsTrain,targetsTrain,tTrain,XTrain,VTrain]=...
%             sequenceDatasetGenerator(m,k(1),X0(1),N(1),nD,totalTime(1),...
%                  imdirTrain,mDir,XScale,imsize,generateImages,classes,...
%                  netCNN,layerName);
%         [inputsValidation,targetsValidation,tValidation,XValidation,VValidation]=...
%             sequenceDatasetGenerator(m,k(2),X0(2),N(2),nD,totalTime(2),...
%                  imdirValidation,mDir,XScale,imsize,generateImages,classes,...
%                  netCNN,layerName);    
%         [inputsTest,targetsTest,tTest,XTest,VTest]=...
%             sequenceDatasetGenerator(m,k(3),X0(3),N(3),nD,totalTime(3),...
%                  imdirTest,mDir,XScale,imsize,generateImages,classes,...
%                  netCNN,layerName);    
end
netCNN=[];
save dataset

