nele=length(mesh.e);
%compute grid metrics
for i=1:nele,
    n1=mesh.e(i,1); n2=mesh.e(i,2); n3=mesh.e(i,3);
    xc(i)=(mesh.x(n1)+mesh.x(n2)+mesh.x(n3))/3;
    yc(i)=(mesh.y(n1)+mesh.y(n2)+mesh.y(n3))/3;
    r(i)=((xc(i)-0.7)^2+(yc(i)+0.7)^2)^0.5;
    dx1=mesh.x(n3)-mesh.x(n2);
    dy1=mesh.y(n3)-mesh.y(n2);
    dx2=mesh.x(n1)-mesh.x(n3);
    dy2=mesh.y(n1)-mesh.y(n3);
    dx3=mesh.x(n2)-mesh.x(n1);
    dy3=mesh.y(n2)-mesh.y(n1);
    area(i)=0.5*(dx3*(-dy2)-(-dx2)*dy3);
    ds(i,1)=(dx1*dx1+dy1*dy1)^0.5;
    ds(i,2)=(dx2*dx2+dy2*dy2)^0.5;
    ds(i,3)=(dx3*dx3+dy3*dy3)^0.5;
    nx(i,1)=dy1/ds(i,1);
    ny(i,1)=-dx1/ds(i,1);
    nx(i,2)=dy2/ds(i,2);
    ny(i,2)=-dx2/ds(i,2);
    nx(i,3)=dy3/ds(i,3);
    ny(i,3)=-dx3/ds(i,3);
end
    
%plot mesh
trifcontour(mesh.e,mesh.x,mesh.y,area);

%solve for velocity distribution at cell centers
u=xc.*(1-xc).*(1-2*yc);
v=-yc.*(1-yc).*(1-2*xc);
%u=0.25*ones(size(xc));
%v=0.0*ones(size(xc));

%define initial condition
for i=1:nele,
    if xc(i) > 0.5,
        c0(i)=0;
    else
        c0(i)=1;
    end
end

trifcontour(mesh.e,x,y,c0)
axis equal

%advance solution in time
dt=0.01;
nstep=86400*100;
nplot=360000;
cnew=c0;
for step=1:nstep,
    cold=cnew;
    for i=1:nele,
        for k=1:3,
            i2=neigh(i,k);
            if i2 > 0,
                uperpl=u(i)*nx(i,k)+v(i)*ny(i,k);
                uperpr=u(i2)*nx(i,k)+v(i2)*ny(i,k);
                uperpf=0.5*(uperpl+uperpr);
                f(k)=0.5*(uperpl*cold(i)+uperpr*cold(i2) ...
                    -abs(uperpf)*(cold(i2)-cold(i)));
                lambda(k)=abs(uperpf);
            else
                f(k)=0;
                lambda(k)=0;
            end
        end
        cr(i)=dt*max([lambda(1)*ds(i,1) lambda(2)*ds(i,2) lambda(3)*ds(i,3)])/area(i);
        cnew(i)=cold(i)-dt/area(i)*(f(1)*ds(i,1)+f(2)*ds(i,2)+f(3)*ds(i,3));
    end
    if (mod(step,nplot) == 0),
       crmax=max(cr);
       fprintf('%d %f \n',step,crmax)
%        trifcontour(mesh.e,mesh.x,mesh.y,cnew)
        dotplot3(xc,yc,cnew,'o',[0 crmax],10,1);
        axis equal
        pause(.1)
    end
end


