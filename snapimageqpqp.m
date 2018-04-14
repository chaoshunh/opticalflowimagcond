clear all;

nt=39;

nx=1001;
nz=301;

dx=10;
dz=10;

%isnap=230;

fStress=fopen('./pfwd.dat','r');

fStressfs = fopen('./sbwd.dat','r'); %../emod2D/Snap_Vx_0','r');

snapCombine=zeros(nz,nx*2);
img=zeros(nz,nx);
shift=0;

%fvxfwd = fopen('vxfwd.dat','w');
%fvzfwd = fopen('vzfwd.dat','w');
fvxbwd = fopen('svxbwd.dat','w');
fvzbwd = fopen('svzbwd.dat','w');
for it=1:nt-shift

offsetSrc=(it-1)*(nx)*(nz)*4;

fseek(fStress,offsetSrc,'bof');
snapStress=fread(fStress,[nz nx],'float');
%snapStress=tmp(61:nz+60,41:nx+40);

offsetRcv=(it-1)*(nx)*(nz)*4; %nt-it for bwd

fseek(fStressfs,offsetRcv,'bof');
snapStressfs=fread(fStressfs,[nz nx],'float');
%snapStressfs=tmp(61:nz+60,41:nx+40);

if( it > 1 )
    %[vxFwd vzFwd]=doOpticalFlow(snapFwdPrev, snapStress);
    [vxBwd vzBwd]=doOpticalFlow(snapBwdPrev, snapStressfs);
    
    %normFwd = sqrt(vxFwd.^2+vzFwd.^2);
    %normBwd = sqrt(vxBwd.^2+vzBwd.^2);
    
    %mycos=0.5+0.5*(vxFwd.*vxBwd+vzFwd.*vzBwd)./(normFwd.*normBwd);
    %[row col]=find(normFwd.*normBwd<=1e-6);
    %mycos(row,col)=0.0;
    
    %fwrite(fvxfwd,vxFwd,'float');
    %fwrite(fvzfwd,vzFwd,'float');
    fwrite(fvxbwd,vxBwd,'float');
    fwrite(fvzbwd,vzBwd,'float');
    img=img+snapStress.*snapStressfs;
end

%snapFwdPrev = snapStress;
snapBwdPrev = snapStressfs;


%alpha=[1.2627,-0.1312, 0.0412,-0.0170, 0.0076,-0.0034, 0.00164,-0.0005];
%[qp qs]=sepqp(snapStress,snapStressfs,dx,dz,alpha);

%img=img+snapStress.*snapStressfs;%./(snapStress.*snapStressfs+0.0000001);;




%figure(1);
%imagesc(snapCombine); colormap(gray(88)); title(strcat('it=',num2str(it)));
%imagesc(qp); colormap(gray(88)); title(strcat('it=',num2str(it)));

%figure(2);
%imagesc(qs); colormap(gray(88)); title(strcat('it=',num2str(it)));
%pause(0.005);
end
%img(:,1:30)=0.0;
%img(:,nx-29:nx)=0.0;

%fclose(fvxfwd);
%fclose(fvzfwd);
fclose(fvxbwd);
fclose(fvzbwd);

figure;
imagesc(img);colormap(gray(88)); 

fid=fopen('newimagePPb.dat','w');
fwrite(fid,img,'float');
fclose(fid);

fclose(fStress);
fclose(fStressfs);