function [truth,axel] = inaxis(mesh,L)
% [truth] = inaxis(x,y)
% [truth,axel] = inaxis(x,y,L)
%  This returns 1 if x,y is inside current figure's axis
%  0 if outside
%  Optional argument axel returns 1,2,3,4 for box side it is outside of
%                1                    
%            _________                       
%      4    |         |   2         
%           |_________|                         
%                3                      
%  1 or 3 have priority in corners
% Used as shorthand test of ginput in or out of field
%  OPTIONAL argin L uses a preset L = axis;
% if x,y are equal length vectors then truth is 
% the result of the find command and axel is not returned
% l = inaxis(x(:),y(:),L);

if nargin==2
x=mesh.x;y=mesh.y;L = axis;
end

if length(x)==1
truth = (x>L(1) & x<L(2) & y>L(3) & y<L(4) );

axel = 0;
if ~truth
if x<L(1)
 axel = 4;
elseif x>L(2) 
 axel = 2;
elseif y<L(3)
 axel = 3;
elseif y>L(4) 
 axel = 1;
end
end


else
truth = find(x>L(1) & x<L(2) & y>L(3) & y<L(4) );
end

