for i=1:29;
fn=[num2str(i) '_dahv.nc'];
u=nc_varget(fn,'dahv_u');
v=nc_varget(fn,'dahv_v');
t=nc_varget(fn,'time')/3600/24+datenum(2012,2,1);
fn=[num2str(i) '_elev.nc'];
z=nc_varget(fn,'elev');
for j=1:length(t);
m=squeeze(sqrt(u(j,:).^2+v(j,:).^2));
colormesh2d(g,m);shading interp;caxis([0 0.5]);colorbar;
title(datestr(t(j)));
pause;
end;
end
end

