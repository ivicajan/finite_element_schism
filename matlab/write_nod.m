function err=write_nod(x,y,fname)
%WRITE_NOD Write a node list to disk in .nod format.
%   WRITE_NOD writes a node list to a file, in the .nod
%   format as specified in the Dartmouth/Thayer School/NML
%   File Standards for the Gulf of Maine projects.
%
%   WRITE_NOD(X,Y,FNAME) opens a file named FNAME in "write" mode 
%   and writes the 2-column node list [X Y] to the filename in 
%   FNAME, including the node counter as  the first column of the  
%   output file. The user should include the .nod file extension
%   in the filename string FNAME.  All arguments are REQUIRED.
%
%   WRITE_NOD returns a 0 if successful and a -1 if not.
% 

if nargin==0 & nargout==0
   disp('Call as: write_nod(x,y,fname)')
   return
end

if nargin~=3,error('WRITE_NOD requires 3 input arguments.'),end

[fid,mesg]=fopen(fname,'w');
% Check for open error
if(fid<0)
   errstr=sprintf('Filename %s could not be opened;\n%s\n',fname,mesg);
   disp(errstr);
   err=-1
else
   i=1:length(x);
   out=[i(:) x(:) y(:)];
   fprintf(fid,'%d %f %f\n',out');
   fclose(fid);
   err=0;
end



%
%        Brian O. Blanton
%        Department of Marine Sciences
%        Ocean Processes Numerical Modeling Laboratory
%        12-7 Venable Hall
%        CB# 3300
%        University of North Carolina
%        Chapel Hill, NC
%                 27599-3300
%
%        919-962-4466
%        blanton@marine.unc.edu
%
%        Summer  1998
%
