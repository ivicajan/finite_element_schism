lat=nc_varget('gebco_bathy.nc','lat',600,3545-600);
lon=nc_varget('gebco_bathy.nc','lon',1150,3757-1150);
z=nc_varget('gebco_bathy.nc','elevation',[600 1150],[3545-600 3757-1150]);
lon2d=repmat(lon',size(lat),1);size(lon2d) 
lat2d=repmat(lat,1,size(lon));size(lat2d)
pcolor(lon2d,lat2d,z);shading flat;colorbar
z=-z;ok=find(z>-10);
size(ok)
f=fopen('xyz.dat','w');
fprintf(f,'%d\n',size(ok,1));
fprintf(f,'%f %f %f\n',[lon2d(ok) lat2d(ok) z(ok)]');
fclose(f);
