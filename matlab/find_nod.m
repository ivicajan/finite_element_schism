function [cvorovi,distance]=find_nod(mreza,lmj,pmj)
% fija racuna minimalnu udaljenost od cvorova mreze
% za zadane koordinate lambda , phi
% zadaje se kao [cvorovi]=find_nod(mreza,lmj,pmj) 

x=mreza.x;
y=mreza.y;
N=length(lmj);
for i=1:N
	xc=lmj(i);
	yc=pmj(i);
	d = (x-xc).^2+(y-yc).^2;
	closest=find(d==min(d));
	if ~isempty(closest)
	   cvorovi(i)=closest(1);
	   distance(i)=d(closest(1));
	else 
	   cvorovi(i)=nan;
	   distance(i)=nan;
	end

end
% i.j.