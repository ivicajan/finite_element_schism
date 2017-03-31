function []=nml2grid(nml_base,grdfile,flag);

% function for transformation of ADCIRC grid files to nml for plot etc..
% function grid2nml(nml_base, gr3file, flag);
% flag =1 za lon.lat flag=2 za metre
if nargin<3 
flag=1;
end;

fileout=grdfile;
if(flag==1)
    mesh=loadgridll(nml_base);
end
if(flag==2)
    mesh=loadgrid(nml_base);
end
 f=fopen(fileout,'w');
fprintf(f,'%s\n',mesh.name);
tmp=[length(mesh.e) length(mesh.x)];
fprintf(f,'%d %d\n',tmp);
ind=1:length(mesh.x);ind=ind';
tmp=[ind mesh.x mesh.y mesh.z];
fprintf(f,'%d %f %f %f\n',tmp');
ind=1:length(mesh.e);ind=ind';
tmp=[ind 3*ones(size(ind)) mesh.e(:,1) mesh.e(:,2) mesh.e(:,3)];
fprintf(f,'%d %d %d %d %d\n',tmp')';
fclose(f);
