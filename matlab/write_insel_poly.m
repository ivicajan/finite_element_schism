function write_insel_poly(in,fout,z);

f=fopen(fout,'w');
np=length(in);
ll=0;
if isfield(in,'lon'); ll=1; disp('Using lon/lat');end
if isfield(in,'x'); ll=2; disp('Using x/y'); end
if ll==0; disp('Have to have lon/lat or x/y in the structure');end
for i=1:np-1;
    fprintf(f,'C island %d\n',i);
       switch ll
       case 1
       for j=1:length(in(i).lon);fprintf(f,'%d %f %f %f\n',j-1,in(i).lon(j),in(i).lat(j),z);end;
       case 2
       for j=1:length(in(i).x);fprintf(f,'%d %f %f %f\n',j-1,in(i).x(j),in(i).y(j),z);end;
       otherwise
       disp('You have to have structure with either lon or lat fields!');
       end
fprintf(f,'-1\n');
end
i=np;
      switch ll
       case 1
       for j=1:length(in(i).lon);fprintf(f,'%d %f %f %f\n',j-1,in(i).lon(j),in(i).lat(j),z);end;
       case 2
       for j=1:length(in(i).x);fprintf(f,'%d %f %f %f\n',j-1,in(i).x(j),in(i).y(j),z);end;
       end
fprintf(f,'-2\n');
fclose(f);
