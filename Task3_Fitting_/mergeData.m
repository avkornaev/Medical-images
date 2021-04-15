function [inputsTrain,targetsTrain,inputsValidation,targetsValidation] =...
    mergeData(inputsTrain,targetsTrain,...
    inputsValidation,targetsValidation,trainRatio)


mergeTVinputs=[inputsTrain;inputsValidation];
mergeTVtargets=[targetsTrain;targetsValidation];
Nm=numel(mergeTVtargets);
rs=randperm(Nm);

Ntrain=ceil(Nm*trainRatio);

%Initialized zero values
inputsTrain = cell(Ntrain,1);
targetsTrain=zeros(Ntrain,1);
inputsValidation=cell(Nm-Ntrain,1);
targetsValidation=zeros(Nm-Ntrain,1);

%Fill the sets
for i=1:Nm
    if i<=Ntrain
        inputsTrain{i,1}=mergeTVinputs{rs(i),1};
        targetsTrain(i,1)=mergeTVtargets(rs(i),1);
    else
        inputsValidation{i-Ntrain,1}=mergeTVinputs{rs(i),1};
        targetsValidation(i-Ntrain,1)=mergeTVtargets(rs(i),1);        
    end
end

end

