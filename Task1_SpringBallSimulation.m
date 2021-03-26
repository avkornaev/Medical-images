clear
clc
close all

%Spring-ball pendulum simulation and visualisation

%% 1. Initialisations and Settings
X0=[.5 .1 .2];%initial position of the ball for train validation and test
XScale=1;
g=9.81;%free fall acceleration
k=[1e3 9e2 1.1e3];%stiffnes for train validation and test
m=1;%mass
totalTime=1e1*[1 1 1];

N=10;%number of time steps
imsize=[224 224];%image size
nD=2;

cd 
mDir=cd;%main directory
imdirTrain='imagesTrain';%subdirectory for images
imdirValidation='imagesValidation';
imdirTest='imagesTest';

generateImages='yes';%'yes','no'

%% 2.Simulation
switch generateImages
    case 'yes'
        mkdir(imdirTrain)%create the folder
        mkdir(imdirValidation)%create the folder
        mkdir(imdirTest)%create the folder
        % Dataset for CNN net
        %train
        [targetsTrain,tTrain]=imgDatasetGenerator(m,k(1),X0(1),N,nD,totalTime(1),imdirTrain,mDir,XScale,imsize);
        %validation
        [targetsValidation,tValidation]=imgDatasetGenerator(m,k(2),X0(2),N,nD,totalTime(2),imdirValidation,mDir,XScale,imsize);
        %test
        [targetsTest,tTest]=imgDatasetGenerator(m,k(3),X0(3),N,nD,totalTime(3),imdirTest,mDir,XScale,imsize);
    case 'no'
        % Dataset for FC net
        %train
        [inputsTrain,targetsTrain,tTrain]=datasetGenerator(m,k(1),X0(1),N,nD,totalTime(1));
        %validation
        [inputsValidation,targetsValidation,tValidation]=datasetGenerator(m,k(2),X0(2),N,nD,totalTime(2));
        %test
        [inputsTest,targetsTest,tTest]=datasetGenerator(m,k(3),X0(3),N,nD,totalTime(3));
end

save dataset

