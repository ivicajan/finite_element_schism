function write_fort14(fem,fileout);
nn=length(fem.x);
ne=length(fem.e);

f=fopen(fileout,'w');
fprintf(f,'DONE WITH write_fort14\n');
fprintf(f,'%d %d\n',ne,nn);
i=1:nn;
fprintf(f,'%d %9.6f %9.6f %6.1f\n',[i' fem.x fem.y fem.z]');
i=1:ne;
fprintf(f,'%d 3 %d %d %d\n',[i' fem.e(:,1) fem.e(:,2) fem.e(:,3)]');
fclose(f);
