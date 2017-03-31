function trinagle2fem(filein,fileout);
% reads triangle output and creates nml format

filenode=[filein,'.node'];
fileele=[filein,'.ele'];
gne=read_node_triangle(filenode);
g_tmp.x=gne(:,1);
g_tmp.y=gne(:,2);
g_tmp.z=gne(:,3);
gne=read_ele_triangle(fileele);
if min(gne(:))==0
    gne(:,1)=gne(:,1)+1;gne(:,2)=gne(:,2)+1;gne(:,3)=gne(:,3)+1;
end
g_tmp.e=gne;
%g_tmp.z=griddata(mesh.x,mesh.y,mesh.z,g_tmp.x,g_tmp.y);
write_ele(g_tmp.e,[fileout,'.ele']);
write_nod(g_tmp.x,g_tmp.y,[fileout,'.nod']);
write_bat(g_tmp.z,[fileout,'.bat']);
mesh=loadgrid(fileout);
mesh=springs(mesh,2);
writegrid(mesh,fileout);
