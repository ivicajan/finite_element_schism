function compute_interp_coefs_gr3(atmo,grid);

% atmo has 2 variables .x and .y
% for example:
% atmo.x=nc_varget('/home/yasha/JRA/all_years_ncss/JRA55_AUS_wget_2011.nc','longitude');
% atmo.y=nc_varget('/home/yasha/JRA/all_years_ncss/JRA55_AUS_wget_2011.nc','latitude'); 
%
% grid has 2 variables .x .y
% g=rad_fort14('hgrid.gr3');
%
%

test=true;
fout='interp_atmo.gr3';

% need vectors
[ny,nx]=size(atmo.x);
if (nx==1)||(ny==1)
   fd.x=atmo.x;
   fd.y=atmo.y;
else
   fd.x=atmp.x(1,1:end);
   fd.y=atmp.y(1:end, 1);
end
% fd.y must start lower left
if (fd.y(1)>fd.y(end))
disp('Flipping lat coordinate!!');
fd.y=flipud(fd.y);
end

delta=1e-9;
nx=length(fd.x);
ny=length(fd.y);
np=length(grid.x);
cf_i=zeros(np,1,'uint32');
cf_j=zeros(np,1,'uint32');
cf_x1=zeros(np,1);
cf_x2=zeros(np,1);
cf_y1=zeros(np,1);
cf_y2=zeros(np,1);
cf_denom=zeros(np,1);
progress(0,0,1);
for i=1:np
cf_i(i)=binarysearch(nx,fd.x,grid.x(i),delta);
cf_j(i)=binarysearch(ny,fd.y,grid.y(i),delta);
cf_x1(i)=grid.x(i)-fd.x(cf_i(i));
cf_x2(i)=fd.x(cf_i(i)+1)-grid.x(i);
cf_y1(i)=grid.y(i)-fd.y(cf_j(i));
cf_y2(i)=fd.y(cf_j(i)+1)-grid.y(i);
cf_denom(i)=(fd.x(cf_i(i)+1)-fd.x(cf_i(i)) )*(fd.y(cf_j(i)+1)-fd.y(cf_j(i)) );
progress(np,i,1);
end

if(test)
testx=repmat(fd.x,1,length(fd.y));
testy=repmat(fd.y',length(fd.x),1);

for i=1:np
     tmpx(i)= (  testx(cf_i(i)  ,cf_j(i)  )*cf_x2(i)*cf_y2(i) + ...
                 testx(cf_i(i)+1,cf_j(i)  )*cf_x1(i)*cf_y2(i) + ...
                 testx(cf_i(i)  ,cf_j(i)+1)*cf_x2(i)*cf_y1(i) + ...
                 testx(cf_i(i)+1,cf_j(i)+1)*cf_x1(i)*cf_y1(i) )/cf_denom(i);
end
d=tmpx(:)-grid.x(:);
fprintf('min/max interpolation error: %f %f\n',min(d),max(d)); 
end

disp(['Writing interp coefs into ' fout]);
f=fopen(fout,'w');
fprintf(f,'i, cf_i(i), cf_j(i), cf_x1(i), cf_x2(i), cf_y1(i), cf_y2(i), cf_denom(i)\n');
for i=1:np;
fprintf(f,'%d %d %d %8.5f %8.5f %8.5f %8.5f %8.5f\n', i, cf_i(i), cf_j(i), cf_x1(i), cf_x2(i), cf_y1(i), cf_y2(i), cf_denom(i));
end
fclose(f);
         