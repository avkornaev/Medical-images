clear all
clc
%Want to know more?
% See "Semantic Segmentation With Deep Learning" on MATLAB Help

%% 0.Preprocess: prepare and load labeled data

cd 'G:\VCS_nailfold_velocity_app'
saveDir=cd;%save main directory

%Use "Image Labeler" Apps to add labels in images.
%Then export labels to file  
load('gTruth')
gTruth
labelsInfo=gTruth.LabelDefinitions

%Fill the background label with ID=4 in the PixelLabelData folder. 
dirlist=dir('PixelLabelData')
dirlist(1:2,:)=[];
cd(dirlist(1).folder)
for i=1:length(dirlist)
    img=imread(dirlist(i).name);
    img(img==0)=4;
    imwrite(img,dirlist(i).name);
    img=[];
end
cd(saveDir)

%% General settings
%Labeling
classNames = [gTruth.LabelDefinitions{:,1}]
% labelIDs=[1 0];

%Augmentation
ang=[-10 10];
sc=[1 1];
sh=[-1 1];
transl=[-20 20]; 

%Semantic segmentation
%Proposed net
 %Input 
  imsize=[224 224 3];
  numClasses = size(gTruth.LabelDefinitions,1);

 %Downsampling
  numFilters = 8;
  filterSize = 9;
  PaddingSize=4;
  poolSize=2;
  StrideSize=2;
  conv=convolution2dLayer(filterSize,numFilters,'Padding',PaddingSize);
  maxPoolDownsample2x=maxPooling2dLayer(poolSize,'Stride',StrideSize);
 
 %Upsampling
  filterSize = 4;
  StrideSize=2;
  CroppingSize=1;% is set to 1 to make the output size = 2 * input size
  transposedConvUpsample2x=...
    transposedConv2dLayer(filterSize,numFilters,'Stride',StrideSize,...
    'Cropping',CroppingSize);

%Training
trainAlgorithm = 'adam'; %'sgdm', 'adam'
InitLearnRate = 1e-4;
MaxEp = 500;
MiniBatchS = 3;
LearnRateDropFact = 0.9;
LearnRateDropPer = 100;

%U-Net
encoderDepth=3;% if unet, 3 if unetplus

%The rest
numObservations=4;
netType='unetplus';% 'proposed' or 'unet' or 'unetplus'

%% Create training data


augmenter = imageDataAugmenter( ...
    'RandRotation',ang, ...
    'RandScale',sc,...
    'RandXShear',sh,...
    'RandYShear',sh,...
    'RandXTranslation',transl,...
    'RandYTranslation',transl);
trainingData = pixelLabelImageDatastore(gTruth,'DataAugmentation',augmenter);

%Analyze training data
 tbl = countEachLabel(trainingData)
totalNumberOfPixels = sum(tbl.PixelCount);
frequency = tbl.PixelCount / totalNumberOfPixels;
classWeights = 1./frequency
% classWeights=ones(numClasses,1);

%% Create the CNN
switch netType
    case 'Proposed'
        [layers] = proposedNet(imsize,numClasses,classWeights,tbl,...
            maxPoolDownsample2x,transposedConvUpsample2x)
        analyzeNetwork(layers)
    case 'unet' %https://www.mathworks.com/help/vision/ref/unetlayers.html
        lgraph = unetLayers(imsize, numClasses,...
            'EncoderDepth',encoderDepth);
        analyzeNetwork(lgraph)
    case 'unetplus'
        [lgraph] = unetplus(imsize,numClasses,classWeights,tbl)
        analyzeNetwork(lgraph)
end

%% Train the CNN 
switch netType
    case 'Proposed'
        opts = trainingOptions('sgdm', ...
            'InitialLearnRate',InitLearnRate, ...
            'MaxEpochs',MaxEp, ...
            'MiniBatchSize',MiniBatchS,...
            'LearnRateDropFactor',LearnRateDropFact, ...
            'LearnRateDropPeriod',LearnRateDropPer, ...
            'Plots','training-progress');
        net = trainNetwork(trainingData,layers,opts);
    case 'unet'
        opts = trainingOptions('adam', ...
        'InitialLearnRate',1e-3, ...
        'MaxEpochs',1000, ...
        'MiniBatchSize',3,...
        'Plots','training-progress');
        net = trainNetwork(trainingData,lgraph,opts)
    case 'unetplus'
        opts = trainingOptions(trainAlgorithm, ...
            'InitialLearnRate',InitLearnRate, ...
            'MaxEpochs',MaxEp, ...
            'MiniBatchSize',MiniBatchS,...
            'LearnRateDropFactor',LearnRateDropFact, ...
            'LearnRateDropPeriod',LearnRateDropPer, ...
            'Plots','training-progress');
        net = trainNetwork(trainingData,lgraph,opts)
end

%% Check the trained CNN
%testImage = imread('img1_00000_00000000213.png');
testImage = imread('img1_00000_00000000829.png');
%testImage = imread('img1_00000_00000000009.png');

%testImage = imread('img1_00000_00000000227.png');
%testImage = imread('img1_00000_00000000233.png');

C = semanticseg(testImage,net);
B = labeloverlay(testImage,C);
figure
imshow(B)

%Create a binary mask of the first class
Mask = C == classNames{1};
figure
imshowpair(testImage, Mask,'montage')

%% 
% tbl = countEachLabel(trainingData)
% 
% totalNumberOfPixels = sum(tbl.PixelCount);
% frequency = tbl.PixelCount / totalNumberOfPixels;
% classWeights = 1./frequency
% 
% 
% layers(end) = pixelClassificationLayer('Classes',tbl.Name,'ClassWeights',classWeights);
% 
% net = trainNetwork(trainingData,layers,opts);
% % 
%  C = semanticseg(testImage,net);
%  B = labeloverlay(testImage,C);
%  imshow(B)
% % 
%  Mask=C==classNames(1);
%  figure
%  imshowpair(testImage, buildingMask,classNames(1))
