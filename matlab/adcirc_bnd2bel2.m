function [segment]=radi_bel_from_adcirc(adcircfile,belfile);
f1=fopen(adcircfile,'r');
f2=fopen(belfile,'w');
f3=fopen('obc_nodes.s2c','w');
fprintf(f2,'mreza_ime \n');
fprintf(f2,'Napravljeno s radi_bel_from_adcirc %s\n',datestr(now));
tmp=fgetl(f1);ii=strmatch('=',tmp(:));
if isfinite(ii);tmp2=str2num(tmp(1:ii-1));else tmp2=str2num(tmp);end
fprintf('I have total number of %d open boundaries!\n',tmp2(1));
tmp=fgetl(f1);ii=strmatch('=',tmp(:));
if isfinite(ii);tmp2=str2num(tmp(1:ii-1));else tmp2=str2num(tmp);end
fprintf('I have total number of %d all other boundaries!\n',tmp2(1));
tmp=fgetl(f1);ii=strmatch('=',tmp(:));
if isfinite(ii);tmp2=str2num(tmp(1:ii-1));else tmp2=str2num(tmp);end
fprintf('I have %d nodes in OB\n',tmp2(1));
n_ob_nodes=tmp2(1);
for j=1:n_ob_nodes;
tmp=fgetl(f1);ii=strmatch('=',tmp(:));
if isfinite(ii);tmp2=str2num(tmp(1:ii-1));else tmp2=str2num(tmp);end
obn(j)=tmp2(1);
end;% cvorovi na otvorenoj granici, flag =5
segment(1).nodes=obn(:);
segment(1).size=length(obn);
segment(1).flag='otvorena granica';
for i=1:length(obn)-1;
    fprintf(f3,'%d \t %d\n',i,obn(i));
    fprintf(f2,'%d \t %d \t %d \t %d \t %d\n',i,obn(i),obn(i+1),0,5);
end
    fprintf(f3,'%d \t %d\n',i+1,obn(i+1));fclose(f3);
ii=i;
%prazna=fgetl(f1);
tmp=fgetl(f1);ind=strmatch('=',tmp(:));
if isfinite(ind);tmp2=str2num(tmp(1:ind-1));else tmp2=str2num(tmp);end
fprintf('I have %d number of Islands and Land\n',tmp2);
n_land_insl_bnd=tmp2(1);

tmp=fgetl(f1);ind=strmatch('=',tmp(:));
if isfinite(ind);tmp2=str2num(tmp(1:ind-1));else tmp2=str2num(tmp);end
n_land_insl_nods=tmp2;
pause;
for i=1:n_land_insl_bnd;
tmp=fgetl(f1);ind=strmatch('=',tmp(:));
if isfinite(ind);tmp2=str2num(tmp(1:ind-1));else tmp2=str2num(tmp);end
nob=tmp2(1);flag=tmp2(2); %broj cvorova i tip
fprintf('%d %d\n',nob,flag);
segment(i+1).size=nob;
clear tmp;
for k=1:nob;
tmp1=fgetl(f1);ind=strmatch('=',tmp1(:));
if isfinite(ind);tmp2=str2num(tmp1(1:ind-1));else tmp2=str2num(tmp1);end;
clear tmp1
tmp(k)=tmp2;
end
segment(i+1).nodes=tmp(:);
if flag==0; %kopno
    segment(i+1).flag='kopno';
for j=1:nob-1;
    ii=ii+1;
    fprintf(f2,'%d \t %d \t %d \t %d \t %d\n',ii,tmp(j),tmp(j+1),0,1);
end
else    %otok
    segment(i+1).flag='otok';
  for j=1:nob-1;
    ii=ii+1;
      fprintf(f2,'%d \t %d \t %d \t %d \t %d\n',ii,tmp(j),tmp(j+1),0,2);
  end
      %spoji otok prvi i zadnji cvor
      fprintf(f2,'%d \t %d \t %d \t %d \t %d\n',ii+1,tmp(j+1),tmp(1),0,2);
      ii=ii+1;
end
end;
fclose(f1);fclose(f2);
