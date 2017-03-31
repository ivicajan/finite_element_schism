function [out1,out2]=genTSicq5(name,mreza,nnv,T,S,times);
%genTSicq4.m
%
% [out1,out2]=genTSicq4(name,mreza,nnv,T,S,times);
%
% Creates an ICQ4 file name.icq4 with T and S varying linearly from
% the surface to the bottom (max depth of bat); The optional length=5
% array times should be [day, mon, yr, sec, deltat], if it is not present
% then [01 01 1996 0.0 300] is used.
%
if(nargin <6);
  times=[01 01 1996 0.0 10];
end
nn=length(mreza.z);

name=[name,'.icq5'];
fid=fopen(name, 'wt');

fprintf(fid,'%s\n','QUODDY5');
fprintf(fid,'%s\n',mreza.name);
fprintf(fid,'%s\n \n','Created by genTSicq5.m');
fprintf(fid,'%d %d\n',nn,nnv);
fprintf(fid,'%d %d %d %f %f\n',times(1),times(2),times(3),times(4),times(5));
%HMID(I),UMID(I),VMID(I),HOLD(I),UOLD(I), VOLD(I)
out1=zeros(nn,6);
out1(:,1)=mreza.z;
fprintf(fid,'%17.9e\t%17.9e\t%17.9e\t%17.9e\t%17.9e\t%17.9e\n',out1');
% ZMID(I,J),ZOLD(I,J),UZMID(I,J),VZMID(I,J),
%        WZMID(I,J),Q2MID(I,J),Q2LMID(I,J),TMID(I,J),
%        SMID(I,J)
out2=zeros(nn*nnv,9);

%mxz=-1*max(bat(:,2));
%ms=ds/mxz;
%mt=dt/mxz;
%bs=srange(1);
%bt=trange(1);
for j=1:nn;
  tmp=sinegrid([-bat(j,2),0],nnv);
  st=nnv*(j-1)+1;
  en=st+nnv-1;
  out2(st:en,1:2)=tmp(:)*[1 1];
end
out2(:,8)=mt*out2(:,1)+bt;
out2(:,9)=ms*out2(:,1)+bs;
out2(:,6)=ones(nn*nnv,1)*0.000001;
out2(:,7)=ones(nn*nnv,1)*0.000001;
fprintf(fid,'%17.9e\t%17.9e\t%17.9e\t%17.9e\t%17.9e\t%17.9e\t%17.9e\t%17.9e\t%17.9e\n',out2');
fclose(fid);
