function [inputs,targets,t,X,V]=...
            imgDatasetGenerator(m,k,X0,N,nD,totalTime,...
                imdir,mDir,XScale,imsize,generateImages,classes)
%Images and 3D dataset generator

%Simulation
t=linspace(0,totalTime,N);%time, s%time, s
omega0=sqrt(k/m);
V=X0*omega0*cos(omega0*t);
X=X0*sin(omega0*t);

%Create dataset of nD depth in time
t=t(1:end-nD+1);
%V=V(1:end-nD+1);

        
switch generateImages
    case 'yes'
        %Create images for the each time step
        figure('Color','w')
        cd(imdir)
    for i=1:N
        [i N]
        plot(X(i),'or','MarkerSize',20,'MarkerEdgeColor','k')
        axis([-XScale XScale -XScale XScale])
        saveas(gcf,['img',num2str(i),'.png'])
        img=imread(['img',num2str(i),'.png']);
        img=imresize(img,imsize);
        imwrite(img,['img',num2str(i),'.png'])
    end
        cd(mDir)
            
        %Read and save images in a matrix form
        inputs=zeros(imsize(1),imsize(2),nD,N-nD+1);
        targets=categorical(classes);
        cd(imdir)
        dirlist=dir; %read subfolder 
        dirlist(1:2)=[];%delete 2 empty elements and one image to make n-n3dl+1 images in each folder
        fs=randperm(N-nD+1);
        for i=1:N-nD+1
            for k=1:nD
                fname=dirlist(fs(i)+k-1).name;
                img = (imread(fname)); %read an image
                img=img(:,:,2);
                inputs(:,:,k,i)=img;
                vel=sign(V(fs(i)+ceil(nD/2)-1))
                switch vel
                    case -1
                        targets(i,1)=categorical(classes(1));
                    case 1
                        targets(i,1)=categorical(classes(2));
                end
            end
        end
        cd(mDir)
    case 'no'
        %Inputs
        iputs=zeros(N-(nD-1),nD);
        for i=1:N-(nD-1)
            inputs(i,:)=X(i:i+(nD-1));
        end
        %Targets
        targets=V(1:end-nD+1);
end

end

