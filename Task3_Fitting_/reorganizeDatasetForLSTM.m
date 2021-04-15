function [inputsOut]=reorganizeDatasetForLSTM(inputsIn)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

s=size(inputsIn);
inputsOut=cell(ones(1,s(end)));

for i=1:s(end)
    for j=1:s(3)
        sub(j)=cell(inputsIn(:,:,j,i));
    end
    inputsOut{1,i}=sub;
end
end

