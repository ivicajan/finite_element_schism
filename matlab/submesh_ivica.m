function [new]=submesh_ivica(mesh,ind);
tmp_e=[];
disp('getting elements');
for i=1:size(mesh.e,1);
	in1=find(mesh.e(i,1)==ind);
	in2=find(mesh.e(i,2)==ind);
	in3=find(mesh.e(i,3)==ind);
	if ~isempty(in1) & ~isempty(in2) & ~isempty(in3) 
		tmp_e=[tmp_e;i]; 	
	end
clear in1 in2 in3
end

disp(['have in total ' num2str(length(tmp_e)) ' elements']);
disp('sorting elements');
[Y,I]=sort(ind);
new.x=mesh.x(Y);
new.y=mesh.y(Y);
new.z=mesh.z(Y);
for i=1:size(tmp_e,1);
in1=find(mesh.e(tmp_e(i),1)==Y);
in2=find(mesh.e(tmp_e(i),2)==Y);
in3=find(mesh.e(tmp_e(i),3)==Y);
if ~isempty(in1); new.e(i,1)=in1;end
if ~isempty(in2); new.e(i,2)=in2;end
if ~isempty(in3); new.e(i,3)=in3;end
clear in1 in2 in3
end
end
