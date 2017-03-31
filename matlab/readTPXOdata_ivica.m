function TPXO=readTPXOdata_ivica(TPXOfile,ROMSnames,lon,lat)
%Read TPXO version 8 data

lonmin=min(lon(:));
lonmax=max(lon(:));
latmin=min(lat(:));
latmax=max(lat(:));

bndx=[lon(1,1) lon(end,1) lon(end,end) lon(1,end)];
bndy=[lat(1,1) lat(end,1) lat(end,end) lat(1,end)];

var={'h'};

count_a6=0;
count_a30=0;
for n=1:length(ROMSnames)
   str=['Harmonic: ' ROMSnames(n)];
   disp(str)
   if strcmp(ROMSnames{n},'MS4') || strcmp(ROMSnames{n},'MN4') || ...
         strcmp(ROMSnames{n},'MF') || strcmp(ROMSnames{n},'MM')
      TPXOfile_grid=TPXOfile.grid.atlas6;
      count_a6=count_a6+1;
      TPXO.('harmonic_a6').harmonic(count_a6)=ROMSnames(n);
   else
      TPXOfile_grid=TPXOfile.grid.atlas30;
      count_a30=count_a30+1;
      TPXO.('harmonic_a30').harmonic(count_a30)=ROMSnames(n);
   end
   TPXOfile_elev=TPXOfile.elev.(lower(ROMSnames{n}));
   file={TPXOfile_elev};
   for i=1:length(var);
      if strcmp(var{i},'h')
         coord='z';
      end
      X=ncread(file{i},['lon_' coord]);
      Y=ncread(file{i},['lat_' coord]);
      I=find((Y>=latmin-0.5)&(Y<=latmax+0.5));
      J=find((X>=lonmin-0.5)&(X<=lonmax+0.5));
      istart=I(1);
      jstart=J(1);
      icount=length(I);
      jcount=length(J);
      
      H=ncread(TPXOfile_grid,['h' coord],[istart jstart],[icount jcount]);
      Z=complex(ncread(file{i},[lower(var{i}) 'Re'],[istart jstart],[icount jcount]),...
                ncread(file{i},[lower(var{i}) 'Im'],[istart jstart],[icount jcount]));

      [x,y]=meshgrid(X(J),Y(I));
      if strcmp(var{i},'h')
         z=double(Z)/1000;
      end
      depth=double(H);
      mask=inpolygon(x,y,bndx,bndy);
      if strcmp(TPXOfile_grid,'grid_tpxo8_atlas6.nc');
         TPXO.(var{i}).x_a6=x;
         TPXO.(var{i}).y_a6=y;
         TPXO.(var{i}).depth_a6=depth;
         TPXO.(var{i}).mask_a6=mask;
         if strcmp(var{i},'h');
            TPXO.(var{i}).z_a6(:,:,count_a6)=z;
         else
            TPXO.(var{i}).z_a6(:,:,count_a6)=z./repmat(TPXO.(var{i}).depth_a6,[1 1 size(z,3)]);
         end
      elseif strcmp(TPXOfile_grid,'grid_tpxo8atlas_30_v1.nc');
         TPXO.(var{i}).x_a30=x;
         TPXO.(var{i}).y_a30=y;
         TPXO.(var{i}).depth_a30=depth;
         TPXO.(var{i}).mask_a30=mask;
         if strcmp(var{i},'h');
            TPXO.(var{i}).z_a30(:,:,count_a30)=z;
         else
            TPXO.(var{i}).z_a30(:,:,count_a30)=z./repmat(TPXO.(var{i}).depth_a30,[1 1 size(z,3)]);
         end
      end
   end
end
