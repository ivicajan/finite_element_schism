function out=integrate_energy_flux(Fx,Fy,g,x,y);
% have to convert from lon lat into metres!!
% it is using brut force approach
x=x(:);y=y(:);Fx=Fx(:);Fy=Fy(:);
% interpolate Fx, Fy onto x,y
fxi=interp_scalar(g,Fx,x,y);
fyi=interp_scalar(g,Fy,x,y);
% get angle and segment length
dx=diff(x);dy=diff(y);
ds=sqrt(dx.^2+dy.^2);
ang=atan2(dy,dx);
dfx=0.5*(fxi(1:end-1)+fxi(2:end));
dfy=0.5*(fyi(1:end-1)+fyi(2:end));
% project 
out.fxi=fxi;out.fyi=fyi;out.ds=ds;
out.flux_y=dfy.*ds.*cos(ang);out.flux_x= dfx.*ds.*sin(ang);
out.length=nansum(ds);
out.angle=ang;
out.total_flux=nansum(out.flux_x+out.flux_y);
