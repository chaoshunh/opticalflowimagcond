function [data]=myresize(img)

Wt = [ 0.05 0.25 0.4 0.25 0.05 ];
m=[ -2:2 ];
[dim1 dim2]=size(img);

newdim1 = dim1*2;
newdim2 = dim2*2;

data = zeros(newdim1,newdim2);

newimg = zeros( dim1+1*2, dim2+1*2);

%padding
%pad rows

newimg(1,2:dim2+1) = img(1,:);
newimg(2:dim1+1,2:dim2+1) = img(:,:);
newimg(dim1+2,2:dim2+1)=img(dim1,:);

%pad columns

newimg(:,1)=newimg(:,2);
newimg(:,dim2+2)=newimg(:,dim2+1);

Wt2 = Wt'*Wt;


for iz = 0:newdim1-1
    for ix = 0:newdim2-1
        z = (iz-m)/2+2;
        idxz=find(floor(z)==z);
        
        x = (ix-m)/2+2;
        idxx=find(floor(x)==x);
        A=newimg( z(idxz), x(idxx) ).*Wt2(m(idxz)+3,m(idxx)+3);
        data(iz+1,ix+1)=4*sum(A(:));
    end
end
