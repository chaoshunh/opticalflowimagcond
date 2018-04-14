function [data]=mypyramid(img)

Wt = [0.05 0.25 0.4 0.25 0.05];
m=[-2:2];

[dim1 dim2]=size(img);

newdim1 = ceil(dim1/2);
newdim2 = ceil(dim2/2);

data = zeros(newdim1,newdim2);

newimg = zeros( dim1+2*2, dim2+2*2);

%padding
%pad rows

newimg(1,3:dim2+2) = img(1,:);
newimg(2,3:dim2+2) = img(1,:);

newimg(3:dim1+2,3:dim2+2) = img(:,:);

newimg(dim1+3,3:dim2+2)=img(dim1,:);
newimg(dim1+4,3:dim2+2)=img(dim1,:);

%pad columns

newimg(:,1)=newimg(:,3);
newimg(:,2)=newimg(:,3);
newimg(:,dim2+3)=newimg(:,dim2+2);
newimg(:,dim2+4)=newimg(:,dim2+2);

Wt2 = Wt'*Wt;

for iz = 0:newdim1-1
    for ix = 0:newdim2-1
        
        A=newimg(2*iz+m+3,2*ix+m+3).*Wt2;
        data(iz+1,ix+1)=sum(A(:));
        
        %oldiz = 2 * (iz-1)+1+2;
        %oldix = 2 * (ix-1)+1+2;
        
        %data(iz,ix) = 0.25*newimg(oldiz,oldix)+0.125*(newimg(oldiz-1,oldix)+newimg(oldiz+1,oldix)+newimg(oldiz,oldix-1)+newimg(oldiz,oldix+1))+0.0625*(newimg(oldiz-1,oldix-1)+newimg(oldiz+1,oldix-1)+newimg(oldiz-1,oldix+1)+newimg(oldiz+1,oldix+1));
    end
end
