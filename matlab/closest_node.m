function nodes=closest_node(femx,femy,x,y);
nn=length(x);
for i=1:nn;
d=sqrt((femx-x(i)).^2+(femy-y(i)).^2);
nodes(i)=find(d==min(d));
end;
