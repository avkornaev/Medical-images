function [inputs,targets,t]=...
            sequenceDatasetGenerator(netCNN,layerName,imdir,mDir,...
            deltaT,nD,V,N)

cd(mDir)%comeback, just in case

%Create an image datastore
imds= imageDatastore(imdir,'IncludeSubfolders', true);
if N == inf
    N=numel(imds.Files);        
end
        

%Simulation
totalTime=deltaT*(N-1);
t=linspace(0,totalTime,N);%time, s

%Create dataset of nD depth in time
%Sequenses
sequences = cell(N,1);
inputs = cell(N-nD+1,1);
targets=zeros(N-nD+1,1);
        
%Read images for the each time step
for i=1:N
    [i N]
    %fname=dirlist(i).name;
    img = (imread(imds.Files{i})); %read an image
    sequences{i,1} = ...
           activations(netCNN,img,layerName,'OutputAs','columns');
end

%Generate sequential dataset
for i=1:N-nD+1
    inputs{i,1}=sequences{i,1};
    startP=i;
    stopP=i+nD-1;
    vel=sgllintegral(V(startP:stopP));
    targets(i,1)=vel;
    for k=1:nD-1
        inputs{i,1}=[inputs{i,1} sequences{i+k,1}];
    end
end

t=t(1:end-nD+1);
end

