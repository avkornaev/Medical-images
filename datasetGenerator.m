function [inputs,targets,t]=datasetGenerator(m,k,X0,N,nD,totalTime)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

t=linspace(0,totalTime,N);%time, s%time, s
omega0=sqrt(k/m);
V=X0*omega0*cos(omega0*t);
X=X0*sin(omega0*t);
for i=1:N-(nD-1)
    inputs(i,:)=X(i:i+(nD-1));
    targets(i,1)=V(i);
end
end

