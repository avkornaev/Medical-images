clear
clc
close all

%Spring-ball pendulum simulation and visualisation

%% 1. Initialisations and Settings
X0=.5;%initial position of the ball
V0=0;%initial velocity
g=9.81;%free fall acceleration
k=1e3;%stiffnes 
m=1;%mass

N=100;%number of time steps
t=linspace(0,1,N);%time, s
imsize=[224 224];%image size


cd 'E:\work\21_AI4MMR\falling ball'
mDir=cd;%main directory
imdir='images';%subdirectory for images

%% 2.Simulation
mkdir(imdir)%create the folder

omega0=sqrt(k/m);
V=X0*omega0*cos(omega0*t);
X=X0*sin(omega0*t);

figure('Color','k')
cd(imdir)
for i=1:N
    X(i)
    plot(X(i),'or','MarkerSize',20,'MarkerFaceColor','r')
    axis([0 2 -X0 X0])
    saveas(gcf,['img',num2str(i),'.png'])
    img=imread(['img',num2str(i),'.png']);
    img=imresize(img,imsize);
    imwrite(img,['img',num2str(i),'.png'])
    %imwrite('ScreenSize',[224 224])
end
cd(mDir)    


