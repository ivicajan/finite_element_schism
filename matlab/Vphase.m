function Vdeg=Vphase(dnum,DN_List)
%************************************************************

t=(dnum+0.5-datenum(1900,1,1))/36525;
tHour=mod(dnum,1)*24;     %Hour of day

DN_Nbr=DN_List(1:7);
DN_Pha=DN_List(:,7);
DN_Spd=DN_List(:,8);

Vs=mod(360*(0.751206 + 1336.855231*t - 0.000003*t*t),360);
Vh=mod(360*(0.776935 +  100.002136*t + 0.000001*t*t),360);
Vp=mod(360*(0.928693 +   11.302872*t - 0.000029*t*t),360);
VN=mod(360*(0.719954 -    5.372617*t + 0.000006*t*t),360);
Vp1=mod(360*(0.781169 +   0.004775*t + 0.000001*t*t),360);
Vs(Vs<0)=Vs(Vs<0)+360;
Vh(Vs<0)=Vh(Vh<0)+360;
Vp(Vp<0)=Vp(Vp<0)+360;
VN(VN<0)=VN(VN<0)+360;
Vp1(Vp1<0)=Vp1(Vp1<0)+360;

Vdeg=tHour*DN_Spd+Vs*DN_Nbr(:,2)+Vh*DN_Nbr(:,3)+...
    Vp*DN_Nbr(:,4)+VN*DN_Nbr(:,5)+Vp1*DN_Nbr(:,6)+DN_Pha;
Vdeg=mod(Vdeg,360);
