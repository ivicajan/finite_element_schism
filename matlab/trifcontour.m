function trifcontour(ele,x,y,f)

% x, y = coordinates of vertices in mesh
% ele = connectivity array
% f = scalar concentration for each element


%fmin=0; %min(f);
%fmax=1; %max(f);

%if fmax > fmin,
%    w=(f-fmin)/(fmax-fmin);
%else
%    w=0.5;
%end

w=f;

nele=size(ele,1);
for i=1:nele,
    for j=1:3,
        X(j,i)=x(ele(i,j));
        Y(j,i)=y(ele(i,j));
        C(1,i,1)=w(i);
        C(1,i,2)=0;
        C(1,i,3)=1-w(i);
    end
end

patch(X,Y,C)

return