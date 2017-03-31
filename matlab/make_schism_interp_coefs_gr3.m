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

test=false;
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
           