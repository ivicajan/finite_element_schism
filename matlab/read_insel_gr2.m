fin='islands.node';
f=fopen(fin,'r');
for j=1:70
tmp=fgetl(f);ii=strmatch('=',tmp(:));
if isfinite(ii);tmp2=str2num(tmp(1:ii-1));else tmp2=str2num(tmp);end
nn=tmp2(1);flag=tmp2(2); %number of nodes and type of boundary
clear nodes;
 for k=1:nn;
    tmp1=fgetl(f);ind=strmatch('=',tmp1(:));
    if isfinite(ind);tmp2=str2num(tmp1(1:ind-1));else;tmp2=str2num(tmp1);end;
         clear tmp1
         nodes(k)=tmp2;
 end
island(j).x=test.x(nodes);
island(j).y=test.y(nodes);
end
fclose(f);

f=fopen('insel.dat','w');
for i=1:length(island);
fprintf(f,'C Island %d\n',i);
fprintf(f,'%d %f %f 1\n',[[1:length(island(i).x)]',island(i).x,island(i).y]');
fprintf(f,'-1\n');
end
fclose(f)

