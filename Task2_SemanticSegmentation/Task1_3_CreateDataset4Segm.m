%% 0.Settings
clear
clc
n=inf;%number of images for train from each folder

imDir='1_2_croppedImages';%init.images directory
trainDir='images4TrainSegm';%images saving directory

%% 1.The list of folders with images 
cd 'G:\VCS_nail_Fold'%current directory
saveDir=cd;%save current directory
mkdir('images4TrainSegm')%create a new folder

cd (imDir)
foldersList=dir;%read content of current folder
foldersList(1:2)=[];%delete
N=length(foldersList);
numb=0;
cd(saveDir)%comeback
%N=1
%% 2. Copy random images to the trainDir 
for I=1:N
    cd(imDir)
    cd(foldersList(I).name);
    dirlist=dir
    dirlist(1:2)=[];%delete
    idx=randperm(length(dirlist),n);%random numbers
    cd(saveDir)
    for J=1:n
        cd(imDir)
        numb=numb+1;
        cd(foldersList(I).name)
        fname=dirlist(idx(J)).name
        img = (imread(fname)); %read and save the first frame into  imgA
        cd(saveDir)
        cd(trainDir)
        imwrite(img, [num2str(numb) '.png'])%save imgA without processing
        cd(saveDir)
    end
end





