clear
clc
close all

%Spring-ball pendulum simulation and visualisation

%% 1. Initialisations and Settings
X0=[.5 .1 .2];%initial position of the ball for train validation and test
g=9.81;%free fall acceleration
k=[1e3 9e2 1.1e3];%stiffnes for train validation and test
m=1;%mass
totalTime=1e0*[1 1 1];

N=1000;%number of time steps
imsize=[224 224];%image size
nD=7;


cd 'G:\springBall2'
mDir=cd;%main directory
imdir='images';%subdirectory for images

generateImages='no';%'yes','no'
%% 2.Simulation


switch generateImages
    case 'yes'
        mkdir(imdir)%create the folder
        figure('Color','w')
        cd(imdir)
        for i=1:N
            [i N]
            plot(X(i),'or','MarkerSize',20,'MarkerFaceColor','r')
            axis([0 2 -X0 X0])
            saveas(gcf,['img',num2str(i),'.png'])
            img=imread(['img',num2str(i),'.png']);
            img=imresize(img,imsize);
            img=imcrop
            imwrite(img,['img',num2str(i),'.png'])
            %imwrite('ScreenSize',[224 224])
        end
        cd(mDir)    
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

