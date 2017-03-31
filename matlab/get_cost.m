function out=get_coast(t,x1,x2,y1,y2);

np=length(t);
cnt=1;
out=[];
for i=1:np
x=t(i).X(1:end-1);y=t(i).Y(1:end-1);
n=length(x); %have nan at the end
ok=find(x>x1&x<x2&y>y1&y<y2&t(i).area>1);
if length(ok)==n
fprintf('.');
out(cnt).x=x;out(cnt).y=y;out(cnt).area=t(i).area;
cnt=cnt+1;
end
end
