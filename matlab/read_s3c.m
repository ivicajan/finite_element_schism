function [data,freq,nnv]=read_s3c(fname)
%READ_S3C read a FEM output file of s3c filetype.
%
% [data,freq,nnv]=read_s3c(fname)
%
%             READ_S3C is part of a suite of OPNML I/O functions  
%             to read specific filetypes pertaining to FEM model  
%             input and output.   These functions allow the user to
%             get these data files into MATLAB without copying the
%             files and removing the header info by hand.
%
%             READ_S3C reads the FEM filetype s3c, as 
%             detailed in "Data File Standards for the Gulf of Maine
%             Project" from the Numerical Methods Laboratory at 
%             Dartmouth College.  (This document is located in the OPNML
%             notebook under External Documents.)  There are four
%             columns, the first of which is the node number.  The
%             remaining columns are floating point.  
%
%   Input :   If fname is omitted, READ_S3C enables a file browser
%             with which the user can specify the .s3c file.
%
%             Otherwise, fname is the name of the s3c file, relative 
%             or absolute (fullpath), including the suffix 's3c'.
%             This input is a string so it must be enclosed in single 
%             quotes. The header lines are discarded.
%  Output :   The data part is returned in the variable data. 
%
%             Call READ_S3C as:
%             >> [data,freq,nnv]=read_s3c(fname);
%             s3c filetypes contain both the frequency and the number 
%             of vertical nodes as header info, which will be returned 
%             to the user.
%
%             If READ_S3C cannot locate the file, it exits, returning 
%             a -1 instead of the data matrix.
%             
%   NOTES :   The .s3c filetype contains 3-D data; i.e., complex-valued
%             scalar data at each vertical node per horizontal node.
%
% Call as: [data,freq,nnv]=read_s3c(fname);
%
% Written by : Brian O. Blanton
%

if ~exist('fname')
   [fname,fpath]=uigetfile('*.s3c','Which .s3c');
   if fname==0,return,end
else
   fpath=[];
end

% get filetype from tail of fname
ftype=fname(length(fname)-2:length(fname));

% make sure this is an allowed filetype
if ~strcmp(ftype,'s3c')
   error(['READ_S3C cannot read ' ftype ' filetype'])
end

% open fname
[pfid,message]=fopen([fpath fname]);
if pfid==-1
   error([fpath fname,' not found. ',message]);
end

% In all filetypes there is always a gridname and description line
% as lines #1 and #2 of the file.
% read grid name from top of file; header line #1
gridname=fgets(pfid);
gridname=blank(gridname);

% read description line from top of file; header line #2
descline=fgets(pfid);

% read frequency and number of vertical nodes from lines #3 and #4
nnv=fscanf(pfid,'%d',1);
freq=fscanf(pfid,'%f',1);

% read data segment 
data=fscanf(pfid,'%d %f %f %f',[4 inf])';
fclose(pfid);
%
%        Brian O. Blanton
%        Department of Marine Sciences
%        15-1A Venable Hall
%        CB# 3300
%        Uni. of North Carolina
%        Chapel Hill, NC
%                 27599-3300
%
%        919-962-4466
%        blanton@marine.unc.edu
%
