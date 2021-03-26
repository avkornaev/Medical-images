function [targets,t]=imgDatasetGenerator(m,k,X0,N,nD,totalTime,imdir,mDir,XScale,imsize)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

t=linspace(0,totalTime,N);%time, s%time, s
omega0=sqrt(k/m);
V=X0*omega0*cos(omega0*t);
X=X0*sin(omega0*t);
targets=X;

figure('Color','w')
cd(imdir)
for i=1:N
    [i N]
    plot(X(i),'or','MarkerSize',20,'MarkerFaceColor','r')
    axis([0 2 -XScale XScale])
    saveas(gcf,['img',num2str(i),'.png'])
    img=imread(['img',num2str(i),'.png']);
    img=imresize(img,imsize);
    imwrite(img,['img',num2str(i),'.png'])
    %imwrite('ScreenSize',[224 224])
end
cd(mDir)
% 
% for i=1:N
%     inputs(i,:)=X(i:i+(nD-1));
%     targets(i,1)=V(i);
% end
% t=t(1:end-nD+1);
end

