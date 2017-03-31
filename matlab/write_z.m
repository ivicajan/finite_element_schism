function write_z(fem,z,fileout);
nn=length(fem.x);
ne=length(fem.e);
f=fopen(fileout,'w');
fprintf(f,'DONE WITH write_z\n');
fprintf(f,'%d %d\n',ne,nn);
i=1:nn;
fprintf(f,'%d %8.4f %8.4f %f\n',[i' fem.x fem.y z]');
fclose(f);
