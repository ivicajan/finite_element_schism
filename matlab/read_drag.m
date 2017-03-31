function [mreza]=read_draq(infile);

f=fopen(infile);
tmp=fgets(f);
domain='test';
mreza.name=domain;
tmp=fscanf(f,'%d %d\n',2);
NE=tmp(1);NN=tmp(2);
tmp=fscanf(f,'%d %f %f %f\n',[4,NN])';
mreza.x=tmp(:,2);mreza.y=tmp(:,3);mreza.z=tmp(:,4);
fclose(f);
