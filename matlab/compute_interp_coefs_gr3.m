function compute_interp_coefs_gr3(wfile,grid);

test=false;
fout='interp_atmo.gr3';
lon_var='lon2d';
lat_var='lat2d';

tmp=nc_varget(wfile,lon_var);
[ny,nx]=size(tmp);
if (nx==1)||(ny==1)
   fd.x=nc_varget(wfile,lon_var,[0],[-1]);
   fd.y=nc_varget(wfile,lat_var,[0],[-1]);
else
   fd.x=nc_varget(wfile,lon_var,[0 0],[1 -1]);
   fd.y=nc_varget(wfile,lat_var,[0 0],[-1 1]);
end

progress(0,0,1);
for i=1:length(grid.x)
            for j= 1:length(fd.x);
              if (grid.x(i)<=fd.x(j));
              break;
              end
            end
              cf_i(i)=j;
            for j=1:length(fd.y);         
              if (grid.y(i)<=fd.y(j));
              break;
              end
            end
              cf_j(i) = j-1;
% for each point compute coefs for bilinear mapping
	    cf_xx1(i) = grid.x(i) - fd.x(cf_i(i));  
	    cf_x2x(i) = fd.x(cf_i(i)+1) - grid.x(i); 
	    cf_yy1(i) = grid.y(i) - fd.y(cf_j(i));
	    cf_y2y(i) = fd.y(cf_j(i)+1) - grid.y(i);
            cf_denom(i) = 1.0/( (fd.x(cf_i(i)+1)-fd.x(cf_i(i))).*(fd.y(cf_j(i)+1)-fd.y(cf_j(i))) );
progress(length(grid.x),i,1);
end

if(test)
testx=repmat(fd.x,1,length(fd.y))';
testy=repmat(fd.y',length(fd.x),1)';

for i=1:length(grid.x)
     tmpx(i)= ( testx(cf_j(i),  cf_i(i)).*cf_x2x(i)*cf_y2y(i) + ...
                testx(cf_j(i)+1,cf_i(i)).*cf_xx1(i)*cf_y2y(i) + ...
                testx(cf_j(i),cf_i(i)+1).*cf_x2x(i)*cf_yy1(i) + ...
                testx(cf_j(i)+1,cf_i(i)+1).*cf_xx1(i)*cf_yy1(i) ).*cf_denom(i);
     tmpy(i)= ( testy(cf_j(i),  cf_i(i)).*cf_x2x(i)*cf_y2y(i) + ...
                testy(cf_j(i)+1,cf_i(i)).*cf_xx1(i)*cf_y2y(i) + ...
                testy(cf_j(i),cf_i(i)+1).*cf_x2x(i)*cf_yy1(i) + ...
                testy(cf_j(i)+1,cf_i(i)+1).*cf_xx1(i)*cf_yy1(i) ).*cf_denom(i);
end
end
disp(['Writing interp coefs into ' fout]);

f=fopen(fout,'w');
fprintf(f,'i, cf_i(i), cf_j(i), cf_x2x(i), cf_xx1(i), cf_y2y(i), cf_yy1(i), cf_denom(i)\n');
for i=1:length(grid.x);
fprintf(f,'%d %d %d %8.5f %8.5f %8.5f %8.5f %8.5f\n', i, cf_i(i), cf_j(i), cf_x2x(i), cf_xx1(i), cf_y2y(i), cf_yy1(i), cf_denom(i));
end
fclose(f);                
           