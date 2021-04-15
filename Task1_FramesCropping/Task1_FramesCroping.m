clear
clc
%Image preprocessor

%% 0.Parameters 
classes=["BT1"];
N=length(classes);%number of classes
noOfImg=4500;%number of images or inf (inf means all files in a folder)
imDir='initImages'
nc=2;%number of clusters

imageSize=[224 224 3];%output images size

%Position and dimensions specified in the crop rectangle rect
x1=360;x2=250; %
rect=[x1 x2 (imageSize(1)-1) (imageSize(2)-1)];

ncr=[1,1];%image cropping by ncr subimages
clustering="off";%clusterisation mode
imit3Layers="on";%imitation of 3 layers in images
adjustImage="off";%adjust images
visualization="off";%
%% 1. Directory
%Current directory
cd 'G:\VCS_nailfold_velocity_app'
saveDir = cd;
%Initial images DataSet folder
cd (imDir)
saveSubDir0=cd;%subdirectory for images given
cd(saveDir)%comeback
%Processed images DataSet folder 
mkdir ("croppedImagesDataset")%create folder
cd croppedImagesDataset
saveSubDir=cd;%subdirectory for images saving
%Create new subfolders for clustered images named as classes
for k=1:N 
        mkdir (classes(k))
end
cd(saveDir)%comeback

%% 2. Images clustering and cropping  
% want to learn more on https://www.mathworks.com/help/images/ref/imsegkmeans.html
for k=1:N
    %Chagne directory, read content of the folder and comeback
    cd (saveSubDir0)
    cd (classes(k))
    dirlist = dir;%read content of current folder
    cd(saveDir)%comeback
    if noOfImg==inf
        n=length(dirlist)
    else
        n=noOfImg
    end
    idx = randperm(length(dirlist),n);%random numbers
    size(idx)
    for j=1:n
        cd (imDir)
        cd (classes(k))
        %Read file name and file size
        fsize = dirlist(j).bytes;
        fname = dirlist(j).name;
        [j dirlist(j).name]
        if fsize > 0
            %Dowload image
            img=imread(fname);
            if  adjustImage=="on"
                img=imadjust(img);
            end
            if clustering == "on"
                % Clusterisation
                L=imsegkmeans(img,nc);
                B=labeloverlay(img,L);
            else
                if imit3Layers=="on" && size(img,3)~=3
                    %Imitation of 3 layers
                    B=cat(3,img,img,img);
                else 
                    B=img;
                end
            end
            B = imcrop(B,rect);%crop image
            cd (saveSubDir0)%comeback 
            %Change directory
            cd (saveSubDir)
            cd (classes(k))
            imwrite(B,(fname)) 
            if visualization=="on"
                imshowpair(img,B, 'montage');
            end
        end
        cd (saveDir)%comback
    end
end
                    
