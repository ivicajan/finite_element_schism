function dt=CFLcheck(mesh);
%CFLCHECK--finds max dt which satisfies dt/dx<1
%
%dt=CFLcheck(ele,nod,UV);
%

%arr=elearea(ele,nod);
arr=mesh.ar;
Umag=sqrt(9.81*abs(mesh.z));
ele=mesh.e;
Uele=[Umag(ele(:,1)),Umag(ele(:,2)),Umag(ele(:,3))];

Uele=max(Uele,[],2);

x=sqrt(2*arr);%length of equivalent 45-45-90 triangle
y=sqrt(2*x.*x);%length of hypotenuese

x=min([x,0.5*y],[],2);%min distance across 45-45-90 triangle

dt=x./Uele;
%dt=min(dt);
