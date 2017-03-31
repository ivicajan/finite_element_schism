function out=read_bnd(in);
% gets structure out holding land, open, island
f=fopen(in,'r');
% open bry
tmp=fgetl(f);ii=strmatch('=',tmp(:));
if isfinite(ii);tmp2=str2num(tmp(1:ii-1));else tmp2=str2num(tmp);end
n_open_boundaries=tmp2(1);
disp(['Number of open boundaries: ' num2str(n_open_boundaries)]);
tmp=fgetl(f);ii=strmatch('=',tmp(:));
if isfinite(ii);tmp2=str2num(tmp(1:ii-1));else tmp2=str2num(tmp);end
nnodes_tot=tmp2(1);
disp(['total number of open boundaries nodes: ' num2str(nnodes_tot)]);
for j=1:n_open_boundaries
fprintf('.%i',j);
tmp=fgetl(f);ii=strmatch('=',tmp(:));
if isfinite(ii);tmp2=str2num(tmp(1:ii-1));else tmp2=str2num(tmp);end
nnodes=tmp2(1);
for i=1:nnodes
out.open(j).nodes(i)=str2num(fgetl(f));
end
end
fprintf('\n');
% land bry
tmp=fgetl(f);ii=strmatch('=',tmp(:));
if isfinite(ii);tmp2=str2num(tmp(1:ii-1));else tmp2=str2num(tmp);end
n_land_boundaries=tmp2(1)
disp(['Number of land boundaries: ' num2str(n_land_boundaries)]);
tmp=fgetl(f);ii=strmatch('=',tmp(:));
if isfinite(ii);tmp2=str2num(tmp(1:ii-1));else tmp2=str2num(tmp);end
nnodes_tot=tmp2(1); 
disp(['total number of land boundary nodes: ' num2str(nnodes_tot)]);
for j=1:n_land_boundaries
tmp=fgetl(f);ii=strmatch('=',tmp(:));
if isfinite(ii);tmp2=str2num(tmp(1:ii-1));else tmp2=str2num(tmp);end
nnodes=tmp2(1);
fprintf('.%i',j);     
for i=1:nnodes
if tmp2(2)==0;out.land(j).nodes(i)=str2num(fgetl(f));end
if tmp2(2)==1;out.island(j).nodes(i)=str2num(fgetl(f));end
end
end
fprintf('\n');
fclose(f);
 