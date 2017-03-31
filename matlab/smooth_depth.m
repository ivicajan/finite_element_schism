function out=smooth_depth(in,w);
% smooth depth for structure using weight w [0,1]
% w=0 do not use surrounding nodes, only local so at the
% end do not smooth; w=1 smooth with surrounding nodes do not use
% local information at all.

% Z_out=(1-w)*Z_in+w*sum(1/d_n * z_n)/sum(1/d_n)

nn=length(in.x);
ne=length(in.e);
out=in;
progress(0,0,1);
for i=1:nn;
% get elements holding that node
ind=find(in.e(:,1)==i | in.e(:,2)==i | in.e(:,3)==i);
nodes=unique(in.e(ind,:));nodes(find(nodes==i))=[];
clear D;
for j=1:length(nodes);
D(j)=1./sqrt( (in.x(nodes(j))-in.x(i)).^2 + ...
              (in.y(nodes(j))-in.y(i)).^2 );
end
 out.z(i)=(1-w)*in.z(i)+ ...
 w*(sum(D(:).*in.z(nodes))/sum(D));
progress(nn,i,1);
end
