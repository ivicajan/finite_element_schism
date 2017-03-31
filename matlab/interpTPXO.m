function VARinterp=interpTPXO(TPXOvar,harmonic,count,lon,lat)
%*****************************************************************
% Extract TPXO data and interpolate onto ROMS grid
% Inputs:
% VAR: hRE, hIm, uRE, uIm, vRe, or vIm
% harmonic: one of: M2 S2 N2 K2 K1 O1 P1 Q1 MF MM M4 MS4 MN4
% lon, lat: 2D arrays of longitude and latitude to interpolate to
% mask: array of 1s and 0s corresponding to wet and dry points of lon & lat
% Output: VARinterp (VAR on lon, lat grid)
% TPXO files must be on the matlab path
% J. Luick, www.austides.com 
% Modified by C James October 2013
%*****************************************************************
   x=TPXOvar.x_a30;
   y=TPXOvar.y_a30;
   z=squeeze(TPXOvar.z_a30(:,:,count));
   depth=TPXOvar.depth_a30;
   m=depth>0;
   F=TriScatteredInterp(x(m),y(m),z(m),'nearest');
   z=F(x,y);
%   disp(['nz ' num2str(length(z(:))) ]);
%   disp(['nx ' num2str(length(x(:))) ]);
%   disp(['ny ' num2str(length(y(:))) ]);
   F=TriScatteredInterp(x(:),y(:),z(:));
   VARinterp=F(lon,lat);

