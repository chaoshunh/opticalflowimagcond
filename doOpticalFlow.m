function [vx, vz]=doOpticalFlow(img1, img2)

%clear all;

numLevels = 3;
windowSize = 9;
iterations = 1;
alpha = 0.001;
hw = floor(windowSize/2);

%pyramids creation
snap1 = img1;
snap2 = img2;
pyramid1 = img1;
pyramid2 = img2;

vx = zeros(size(img1));
vz = zeros(size(img1));

%size(pyramid1)

%figure;
%subplot 121; imagesc(img1);
%subplot 122; imagesc(img2);

%init
for i=2:numLevels
    snap1=impyramid(img1,'reduce');
    snap2=impyramid(img2,'reduce');
    %snap1 = mypyramid(snap1);
    %snap2 = mypyramid(snap2);
    %size(img1,1)
    %size(img1,2)
    pyramid1(1:size(snap1,1),1:size(snap1,2),i)=snap1;
    pyramid2(1:size(snap2,1),1:size(snap2,2),i)=snap2;
    %size(pyramid1)
    
    %figure;
    %subplot 121; imagesc(img1);
    %subplot 122; imagesc(img2);    
end

%processing all levels
for p=1:numLevels
    %current pyramid
    snap1 = pyramid1(1:(size(pyramid1,1)/(2^(numLevels-p))), 1:(size(pyramid1,2)/(2^(numLevels-p))), (numLevels-p)+1);
    snap2 = pyramid2(1:(size(pyramid2,1)/(2^(numLevels-p))), 1:(size(pyramid2,2)/(2^(numLevels-p))), (numLevels-p)+1);

    %init
    if p==1
        u=zeros(size(snap1));
        v=zeros(size(snap2));
    else
        %resizing
        u=2*imresize(u,size(u)*2,'bilinear');
        v=2*imresize(v,size(v)*2,'bilinear');
    end
    
    %refinement loop
    for r=1:iterations
        u=round(u);
        v=round(v);
        
        %every pixel loop
        for i=1+hw:size(snap1,1)-hw
            for j=1+hw:size(snap1,2)-hw
                
                patch1=snap1(i-hw:i+hw,j-hw:j+hw);
                
                %moved patch
                lr = i-hw+v(i,j);
                hr = i+hw+v(i,j);
                lc = j-hw+u(i,j);
                hc = j+hw+u(i,j);
                
                if (lr<1) || (hr>size(snap1,1)) || (lc<1) || (hc>size(snap1,2))
                    %regularized least square processing
                else
                    patch2 = snap2(lr:hr,lc:hc);
                    fx=conv2(patch1,0.25*[-1 1; -1 1])+conv2(patch2,0.25*[-1 1; -1 1]);
                    fz=conv2(patch1,0.25*[-1 -1; 1 1])+conv2(patch2,0.25*[-1 -1; 1 1]);
                    ft=conv2(patch1,0.25*ones(2))+conv2(patch2,-0.25*ones(2));
                    
                    Fx=fx(2:windowSize-1,2:windowSize-1)';
                    Fz=fz(2:windowSize-1,2:windowSize-1)';
                    Ft=ft(2:windowSize-1,2:windowSize-1)';
                    
                    A=[Fx(:) Fz(:)]; % column by column for Fx and Fz and get 2 columns
                    G=A'*A;
                    
                    G(1,1)=G(1,1)+alpha;
                    G(2,2)=G(2,2)+alpha;
                    U=1/(G(1,1)*G(2,2)-G(1,2)*G(2,1))*[G(2,2) -G(1,2); -G(2,1) G(1,1)]*A'*(-Ft(:));
                    u(i,j)=u(i,j)+U(1);
                    v(i,j)=v(i,j)+U(2);
                end
            end
        end
    end %for iteration
end %for iLevel

[n1u,n2u]=size(u);
%size(v)
for ix=1:n2u
    for iz=1:n1u
        vx(iz,ix)=u(iz,ix);
        vz(iz,ix)=v(iz,ix);
    end
end





