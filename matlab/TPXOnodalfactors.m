function [fFac,uFac]=TPXOnodalfactors(dnum,Names)

%f and u factors for the harmonics listed in cell array Names.
%(e.g. Names={'MM' 'M2' S2'};
%Only those which are in the TPXO model are evaluated.
%They are evaluated at time dnum (a Matlab datenumber).
%See Table xxvi in A.T. Doodson (1928) 'On the Analysis of Tidal Observations'
%Philosophical Transactions of the Royal Society of London. Series A, Vol. 227
%J. Luick, Thanksgiving Day, 2011, Adelaide

%if f and u are not reassigned below, they are probably solar
%terms, i.e. have f=1 and u=0.
f=struct;
u=struct;
% fFac=ones(length(Names),1);
% uFac=zeros(length(Names),1);

t=(dnum+0.5-datenum(1900,1,1))/36525;
VN=mod(360*(0.719954-5.372617*t+0.000006*t*t),360);
VN(VN<0)=VN(VN<0)+360;
VN=VN*pi/180;

%coefficients
cN=cos(VN);
c2N=cos(2*VN);
c3N=cos(3*VN);
sN=sin(VN);
s2N=sin(2*VN);
s3N=sin(3*VN);

%Assign values for f and u of nonsolar constituents
%Doodson Table XXVI (with u*pi/180)
f.MM=1.0-0.1300*cN+0.0013*c2N;
u.MM=0;
f.MF=1.0429+0.4135*cN-0.004*c2N;
u.MF=-0.4143*sN+0.0468*s2N-0.0066*s3N;

f.O1=1.0089+.1871*cN-0.0147*c2N+0.0014*c3N;
u.O1=0.1885*sN-0.0234*s2N+0.0033*s3N;

f.K1=1.0060+0.1150*cN-0.0088*c2N+0.0006*c3N;
u.K1=-0.1546*sN+0.0119*s2N-0.0012*s3N;

f.M2=1.0004-0.0373*cN+0.0002*c2N;
u.M2=-0.0374*sN;

f.K2=1.0241+0.2863*cN+0.0083*c2N-0.0015*c3N;
u.K2=-0.3096*sN+0.0119*s2N-0.0007*s3N;

% dependent values
f.Q1=f.O1;
u.Q1=u.O1;
f.N2=f.M2;
u.N2=u.M2;
f.MN4=f.M2^2;
u.MN4=2*u.M2;
f.M4=f.M2^2;
u.M4=2*u.M2;
f.MS4=f.M2;
u.MS4=u.M2;


%Assign fFac and uFac
for n=1:length(Names)
    if isfield(f,Names{n});
        fFac.(Names{n})=f.(Names{n});
        uFac.(Names{n})=mod(u.(Names{n})*180/pi,360);
    else
        %if f and u are not assigned, they are probably solar 
        %terms, i.e. have f=1 and u=0.
        fFac.(Names{n})=1;
        uFac.(Names{n})=0;
    end
end

