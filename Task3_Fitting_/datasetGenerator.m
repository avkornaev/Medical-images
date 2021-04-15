function [inputs,targets,t]=datasetGenerator(m,k,X0,N,nD,totalTime)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%Simulation
t=linspace(0,totalTime,N);%time, s
omega0=sqrt(k/m);
V=X0*omega0*cos(omega0*t);
X=X0*sin(omega0*t);

%Create dataset of nD depth in time
t=t(1:end-nD+1);
%Targets
targets=V(1:end-nD+1);

%Inputs
inputs=zeros(N-(nD-1),nD);
for i=1:N-(nD-1)
    inputs(i,:)=X(i:i+(nD-1));
end

end

