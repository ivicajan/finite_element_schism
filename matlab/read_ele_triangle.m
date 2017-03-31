function [out]=read_node_triangle(file);
f=fopen(file);
t=fscanf(f,'%d %d %d %d\n',4);
d=fscanf(f,'%d %d %d %d\n',[4,t(1)])';
fclose(f);
if min(d(:)==0)
% have to start from 1 not from 0
d(:,2:4)=d(:,2:4)+1;
end

out=d(:,2:4);
