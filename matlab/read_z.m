function [z]=read_z(infile);
f=fopen(infile);
tmp=fgets(f);
tmp=fscanf(f,'%d %d\n',2);
NN=tmp(2);
tmp=fscanf(f,'%d %f %f %f\n',[4,NN])';
z=tmp(:,4);
fclose(f);
