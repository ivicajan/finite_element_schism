function [out]=radi_bel_from_adcirc(adcircfile,belfile);
% loads adcirc bnd_extr format and create bel file with loading segments
% creates obc_nodes.s2c file with list of open boundary nodes.
% IJ 2014, Dec
f1=fopen(adcircfile,'r');
f2=fopen(belfile,'w');
f3=fopen('obc_nodes.s2c','w');
fprintf(f2,'mesh_name \n');
fprintf(f2,'Done with radi_bel_from_adcirc %s\n',datestr(now));
% get number of open bounries
tmp=fgetl(f1);
ii=strmatch('=',tmp(:));
if isfinite(ii);tmp2=str2num(tmp(1:ii-1));else tmp2=str2num(tmp);end
n_ob=tmp2;
fprintf('I have total number of %d open boundaries!\n',n_ob);
% get total number of open boundary nodes
tmp=fgetl(f1);ii=strmatch('=',tmp(:));
if isfinite(ii);tmp2=str2num(tmp(1:ii-1));else tmp2=str2num(tmp);end
tn_ob_nodes=tmp2;
fprintf('I have total number of %d  nodes on the %d boundaries!\n',tn_ob_nodes,n_ob);
% loop through OB and read nodes
cnt2=1;cnt3=1;
for j=1:n_ob;
        tmp=fgetl(f1);ii=strmatch('=',tmp(:));
        if isfinite(ii);tmp2=str2num(tmp(1:ii-1));else tmp2=str2num(tmp);end
        n_nodes=tmp2;
        fprintf('I have %d nodes in OB %d\n',n_nodes,j);
        for jj=1:n_nodes
                tmp=fgetl(f1);ii=strmatch('=',tmp(:));
                if isfinite(ii);tmp2=str2num(tmp(1:ii-1));else tmp2=str2num(tmp);end
                obn(jj)=tmp2(1);
        end;% done reading OB nodes
        out.open(j).nodes=obn(:);
        % write obc_nodes.s2c file
        for i=1:length(obn)-1;
                fprintf(f2,'%d \t %d \t %d \t %d \t %d\n',cnt2,obn(i),obn(i+1),0,5);
                cnt2=cnt2+1;
        end
        for i=1:length(obn);
                fprintf(f3,'%d \t %d\n',cnt3,obn(i));
                cnt3=cnt3+1;
        end
                clear obn;
end % done with open boundaries
fclose(f3);
% get land and island structure
tmp=fgetl(f1);ind=strmatch('=',tmp(:));
if isfinite(ind);tmp2=str2num(tmp(1:ind-1));else tmp2=str2num(tmp);end
n_land_isl_bnd=tmp2(1);
fprintf('I have %d number of islands and land boundaries\n',n_land_isl_bnd);
tmp=fgetl(f1);ind=strmatch('=',tmp(:));
if isfinite(ind);tmp2=str2num(tmp(1:ind-1));else tmp2=str2num(tmp);end
tn_land_nodes=tmp2;
fprintf('I have total number of %d nodes on %d land boundaries\n',tn_land_nodes,n_land_isl_bnd);
% get number of nodes in boundary and type
for j=1:n_land_isl_bnd;
        tmp=fgetl(f1);ind=strmatch('=',tmp(:));
        if isfinite(ind);tmp2=str2num(tmp(1:ind-1));else tmp2=str2num(tmp);end
        nn=tmp2(1);flag=tmp2(2); %number of nodes and type of boundary
        fprintf('%d %d\n',nn,flag);
        clear nodes;
        for k=1:nn;
                tmp1=fgetl(f1);ind=strmatch('=',tmp1(:));
                if isfinite(ind);tmp2=str2num(tmp1(1:ind-1));else tmp2=str2num(tmp1);end;
                clear tmp1
                nodes(k)=tmp2;
        end
        out.land(j).nodes=nodes(:);
% write down bel structure for land
        if flag==0; %no normal flux land
                out.land(j).flag=flag;
                for i=1:nn-1;
                        fprintf(f2,'%d \t %d \t %d \t %d \t %d\n',cnt2,nodes(i),nodes(i+1),0,1);
                        cnt2=cnt2+1;
                end
        else    %island
                out.land(j).flag=flag;
                for i=1:nn-1;
                        fprintf(f2,'%d \t %d \t %d \t %d \t %d\n',cnt2,nodes(i),nodes(i+1),0,2);
                cnt2=cnt2+1;
                end
                %connect first and last node of the island
                fprintf(f2,'%d \t %d \t %d \t %d \t %d\n',cnt2,nodes(i+1),nodes(1),0,2);
                cnt2=cnt2+1;
        end
end;
fclose(f1);fclose(f2);

