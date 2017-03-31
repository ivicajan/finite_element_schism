function [out]=read_node_triangle(file);
f=fopen(file);
t=fscanf(f,'%d %d %d %d\n',4);

switch t(4)
case 1
data=fscanf(f,'%d %f %f %f %f\n',[5,t(1)])';
case 0
data=fscanf(f,'%d %f %f %f\n',[4,t(1)])';
otherwise
disp('not reckognizing node format');
end
fclose(f);
out=data(:,2:4);
