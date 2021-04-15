function [layers] = LSTMplus(numFeatures,depth)
%UNTITLED Summary of this function goes here

layers = [
    sequenceInputLayer(numFeatures,'Name','sequence')
    bilstmLayer(depth,'OutputMode','last','Name','bilstm')
    dropoutLayer(0.5,'Name','drop')
    fullyConnectedLayer(1,'Name','fc')
    regressionLayer('Name','regression')];
    %softmaxLayer('Name','softmax')
    %classificationLayer('Name','classification')];


end

