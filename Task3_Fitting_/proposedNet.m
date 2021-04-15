function [layers] = proposedNet(imsize,numClasses)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
layers = [
    imageInputLayer([224 224 3],"Name","imageinput")
    convolution2dLayer([11 11],128,"Name","conv","Padding","same")
    reluLayer("Name","relu")
    dropoutLayer(0.5,"Name","dropout")
    maxPooling2dLayer([224 224],"Name","maxpool")
    fullyConnectedLayer(2,"Name","fc")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];
end

