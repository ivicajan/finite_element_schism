function [arr]=elearea(ele,nod);

%
%ele(:,1:3);
%nod(:,1:2);
%
x=nod(:,1);
y=nod(:,2);

i1=ele(:,1);
i2=ele(:,2);
i3=ele(:,3);
dx1=x(i2)-x(i3);
dx2=x(i3)-x(i1);
dx3=x(i1)-x(i2);
dy1=y(i2)-y(i3);
dy2=y(i3)-y(i1);
dy3=y(i1)-y(i2);
arr=0.5*(x(i1).*dy1 + x(i2).*dy2 + x(i3).*dy3);
