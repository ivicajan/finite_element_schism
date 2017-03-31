function fem=springs(fem,iter);
%springs::Move internal points of finite element mesh such that the mesh quality is improved.
%
%       Each point not located along the boundary is moved toward
%       the center of mass of the polygon formed by the adjacent
%       triangles. The process is repeated ITER times.
%
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 
%Courtesy of Jayaram Veeramony
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 


if nargin==1,
  iter=5;
end
 
e=fem.e';
x=fem.x';
y=fem.y';
fem.bnd=detbndy(fem.e); 
bn=unique(fem.bnd)';
i=ones(size(x));
i(bn)=i(bn)*0;
i=find(i);
 
np= size(x,2);
 
j=1;
while j<=iter
  X=sparse(e([1 2 3],:),e([2 3 1],:),x(e(1:3,:)),np,np);
  Y=sparse(e([1 2 3],:),e([2 3 1],:),y(e(1:3,:)),np,np);
  N=sparse(e([1 2 3],:),e([2 3 1],:),1,np,np);
  m=sum(N);
  X=sum(X)./m;                                                                                                                                                 
  Y=sum(Y)./m;
  x(i) = X(i);
  y(i) = Y(i);
  j=j+1;
end
 
fem.x=x(:);
fem.y=y(:);
 
function q=triqual(fem_struct);
%  TRIQUAL Triangle quality measure
%
%  Q=TRIQUAL(FEM_STRUCT) returns a triangle quality measure given
%  triangle data. The triangle quality is given by the formula
%
%  q = 4*sqrt(3)*A/(l1^2+l2^2+l3^2)
%
%  where A is the area and l1, l2, and l3 are the side lengths. If
%  q>0.6 the triangle is of acceptable quality. q=1 when l1=l2=l3.
 
 
x=fem_struct.x;
y=fem_struct.y;
e=fem_struct.e;
A=fem_struct.ar;
 
l3sq=(x(e(:,1))-x(e(:,2))).^2+(y(e(:,1))-y(e(:,2))).^2;
l1sq=(x(e(:,2))-x(e(:,3))).^2+(y(e(:,2))-y(e(:,3))).^2;
l2sq=(x(e(:,3))-x(e(:,1))).^2+(y(e(:,3))-y(e(:,1))).^2;
 
q=4*sqrt(3)*A./(l1sq+l2sq+l3sq);                                                                                                                             