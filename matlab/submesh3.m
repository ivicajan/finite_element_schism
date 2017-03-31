function [njoin,mesh1,mesh2] =...  
         submesh2(lnod,mesh)
% submesh2.m   Nov 2, 1995 alterations for speed
%  [njoin,meshnod1,meshele1,bathy1,meshnodsub,meshelesub,bathysub] =...  
%         submesh2(lnod,meshnod,meshele,bathy)  ;
% submesh extraction routine
% lnod is the list of nodes in the submesh
% meshnod1, meshele1  are the old mesh
% meshnod2,meshele2 are the sub mesh
%
% e.g.
% load mesh1all
% L = newaxis(meshnod);
%lnod = inaxis(meshnod(:,2),meshnod(:,3),L);
% submesh2(lnod,meshnod,meshele,bathy)  ;
disp('Submesh2ing nov. 2 ')
tic
i1 = mesh.e(:,3);
j1 = mesh.e(:,1);
i2 = mesh.e(:,1);
j2 = mesh.e(:,2);
i3 = mesh.e(:,2);
j3 = mesh.e(:,3);

l = [1:length(mesh.e(:,1))]';
S = sparse([i1;i2;i3],[j1;j2;j3],[l;l;l]);
X = S(:,lnod);
[l,m] = find(X>0);
lele = l;
for i = 1:length(l)
lele(i) = X(l(i),m(i));
end

lele = union(lele,[]);

disp([' first loop lele  ',num2str(toc)]);tic
 
% Now find the nodes which are in the elements, but not
% in the node list.  These are just outside the region!    lout
lout = nan*ones(3*length(lele),1); louti = 0;
for i = 1:length(lele)
n1 = find(mesh.x(lnod)==mesh.e(lele(i),1));
n2 = find(mesh.x(lnod)==mesh.e(lele(i),2));
n3 = find(mesh.x(lnod)==mesh.e(lele(i),3));

if isempty(n1)
louti = louti+1; lout(louti) =  mesh.e(lele(i),1) ;
end
if isempty(n2)
louti = louti+1; lout(louti) = mesh.e(lele(i),2) ;
end
if isempty(n3)
louti = louti+1; lout(louti) = mesh.e(lele(i),3) ;
end 
end
lout = lout(find(~isnan(lout)));
lout = union(lout,[]);
disp([' second loop lout ',num2str(toc)]);tic


% Renumber the nodes so that subnodes are at end of list
nn = length(mesh.x);
ne = length(mesh.e);
lnew = [lout' ;lnod];
lold = 1:nn;
lold(lnew) = NaN*lold(lnew);
lold = find(~isnan(lold));
lrenum = [lold'; lnew];
lchange = lrenum;
for i = 1:length(lrenum)
lchange(lrenum(i)) = i;
end

disp([' renumbering old  ',num2str(toc)]);tic

meshnew = mesh;
meshnew.x = mesh.x(lrenum);
meshnew.y = mesh.y(lrenum);
meshnew.z = mesh.z;
meshnew.z = mesh.z(lrenum);

meshnew.e = mesh.e;
meshnew.e(:,1) = lchange(mesh.e(:,1));
meshnew.e(:,2) = lchange(mesh.e(:,2));
meshnew.e(:,3) = lchange(mesh.e(:,3));

disp([' renumbering new  ',num2str(toc)]);tic

nn = length(mesh.x);
nodsold = 1:(nn-length(lnew));
nodsbnd = (nn-length(lnew)+1):(nn-length(lnod)) ;
nodsnew = (nn-length(lnod)+1):nn;

nend = nan*zeros(length(meshnew.e),1);ne = 0;
nbegin = nend;nb = 0;
for i = 1:length(meshnew.e)
if ~isempty([find(meshnew.e(i,1)==nodsnew) ...
    find(meshnew.e(i,2)==nodsnew) find(meshnew.e(i,3)==nodsnew)]);
ne = ne+1;
nend(ne) = i;
else
nb =nb+1;
nbegin(nb) = i;
end
end
nend=nend(1:ne);
nbegin=nbegin(1:nb);

disp([' Find elements nend, nbegin  ',num2str(toc)]);tic


mesh1.e = meshnew.e(nbegin,:);
mesh2.e = meshnew.e(nend,:);
mesh2.e(:,1:3) = mesh2.e(:,1:3)-length(lold);
mesh1.x = meshnew.x(1:(nn-length(lnod)),1);
mesh1.y = meshnew.y(1:(nn-length(lnod)),2);
mesh1.z = meshnew.z(1:(nn-length(lnod)),:);
mesh2.x = meshnew.x([(length(lold)+1):nn],:);
mesh2.y = meshnew.y([(length(lold)+1):nn],:);
mesh2.z = meshnew.z([(length(lold)+1):nn],:);
njoin = length(lout);

 
disp('Done with Submesh')
