function combine_output(i1,i2,ntimes,var);
for i=i1:i2;
f=fopen('combine_output.in','w');
fprintf(f,'%s\n',var);
fprintf(f,'%d %d\n',i,i);
fprintf(f,'1\n');fprintf(f,'1 %d\n',ntimes);fclose(f);
system('/home/ivica/bin/combine_output');
end;
