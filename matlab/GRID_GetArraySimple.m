function TheArray=GRID_GetArraySimple(GridFile)

LON_rho=nc_varget(GridFile,'lon_rho');
LAT_rho=nc_varget(GridFile,'lat_rho');
LON_psi=nc_varget(GridFile,'lon_psi');
LAT_psi=nc_varget(GridFile,'lat_psi');
LON_u=nc_varget(GridFile,'lon_u');
LAT_u=nc_varget(GridFile,'lat_u');
LON_v=nc_varget(GridFile,'lon_v');
LAT_v=nc_varget(GridFile,'lat_v');
MSK_rho=nc_varget(GridFile,'mask_rho');
MSK_u_read=nc_varget(GridFile,'mask_u');
MSK_v_read=nc_varget(GridFile,'mask_v');
MSK_psi_read=nc_varget(GridFile,'mask_psi');
DEP_rho=nc_varget(GridFile,'h');
ANG_rho=nc_varget(GridFile,'angle');
pm_rho=nc_varget(GridFile,'pm');
pn_rho=nc_varget(GridFile,'pn');
fCoriolis=nc_varget(GridFile,'f');
dndx=nc_varget(GridFile,'dndx');
dmde=nc_varget(GridFile,'dmde');
%
TheArray.GridFile=GridFile;
TheArray.LON_rho=LON_rho;
TheArray.LAT_rho=LAT_rho;
TheArray.LON_psi=LON_psi;
TheArray.LAT_psi=LAT_psi;
TheArray.LON_u=LON_u;
TheArray.LAT_u=LAT_u;
TheArray.LON_v=LON_v;
TheArray.LAT_v=LAT_v;
TheArray.fCoriolis=fCoriolis;
%
TheArray.dndx=dndx;
TheArray.dmde=dmde;
%
[eta_rho, xi_rho]=size(LON_rho);
[eta_u, xi_u]=size(LON_u);
[eta_v, xi_v]=size(LON_v);
TheArray.eta_rho=eta_rho;
TheArray.eta_psi=eta_rho-1;
TheArray.eta_u=eta_u;
TheArray.eta_v=eta_v;
TheArray.xi_rho=xi_rho;
TheArray.xi_psi=xi_rho-1;
TheArray.xi_u=xi_u;
TheArray.xi_v=xi_v;
%
SIZ_rho=eta_rho*xi_rho;
SIZ_u=eta_u*xi_u;
SIZ_v=eta_v*xi_v;
SIZ_uv=SIZ_u+SIZ_v;
TheArray.SIZ_rho=SIZ_rho;
TheArray.SIZ_u=SIZ_u;
TheArray.SIZ_v=SIZ_v;
TheArray.SIZ_uv=SIZ_uv;
%
MSK_v=MSK_rho(1:eta_rho-1,:).*MSK_rho(2:eta_rho,:);
MSK_u=MSK_rho(:,1:xi_rho-1).*MSK_rho(:,2:xi_rho);
MSK_psi=MSK_rho(1:eta_rho-1,1:xi_rho-1).*...
        MSK_rho(2:eta_rho,1:xi_rho-1).*...
        MSK_rho(1:eta_rho-1,2:xi_rho).*...
        MSK_rho(2:eta_rho,2:xi_rho);
MSKdist_u=sum(abs(MSK_u(:) - MSK_u_read(:)));
MSKdist_v=sum(abs(MSK_v(:) - MSK_v_read(:)));
MSKdist_psi=sum(abs(MSK_psi(:) - MSK_psi_read(:)));
if (MSKdist_u > 1/2 || MSKdist_v > 1/2 || MSKdist_psi > 1/2)
  disp('The mask of your grid are not correct!!!!');
  error('Please correct');
end;


TheArray.MSK_rho=MSK_rho;
TheArray.MSK_psi=MSK_psi;
TheArray.MSK_u=MSK_u;
TheArray.MSK_v=MSK_v;
MSKbound_rho=zeros(eta_rho, xi_rho);
MSKbound_rho(1, :)=1;
MSKbound_rho(:, 1)=1;
MSKbound_rho(eta_rho, :)=1;
MSKbound_rho(:, xi_rho)=1;
Kbound_rho=find(MSKbound_rho == 1);
TheArray.MSKbound_rho=MSKbound_rho;
TheArray.Kbound_rho=Kbound_rho;
%
ANG_u=(ANG_rho(:, 1:xi_u)+ANG_rho(:, 2:xi_rho))/2;
ANG_v=(ANG_rho(1:eta_v, :)+ANG_rho(2:eta_rho, :))/2;
ANG_psi=(ANG_rho(1:eta_rho-1,1:xi_rho-1)+...
           ANG_rho(2:eta_rho,1:xi_rho-1)+...
           ANG_rho(1:eta_rho-1,2:xi_rho)+...
           ANG_rho(2:eta_rho,2:xi_rho))/4;
TheArray.ANG_rho=ANG_rho;
TheArray.ANG_psi=ANG_psi;
TheArray.ANG_u=ANG_u;
TheArray.ANG_v=ANG_v;
%
%
DEP_u=(DEP_rho(:, 1:xi_u)+DEP_rho(:, 2:xi_rho))/2;
DEP_v=(DEP_rho(1:eta_v, :)+DEP_rho(2:eta_rho, :))/2;
DEP_psi=(DEP_rho(1:eta_rho-1,1:xi_rho-1)+...
           DEP_rho(2:eta_rho,1:xi_rho-1)+...
           DEP_rho(1:eta_rho-1,2:xi_rho)+...
           DEP_rho(2:eta_rho,2:xi_rho))/4;
TheArray.DEP_rho=DEP_rho;
TheArray.DEP_psi=DEP_psi;
TheArray.DEP_u=DEP_u;
TheArray.DEP_v=DEP_v;
%
mn_rho=pm_rho.*pn_rho;
mn_psi=(mn_rho(1:eta_rho-1,1:xi_rho-1)+mn_rho(1:eta_rho-1,2:xi_rho)+...
	mn_rho(2:eta_rho,2:xi_rho)+mn_rho(2:eta_rho,1:xi_rho-1))/4;
TheArray.pm_rho=pm_rho;
TheArray.pn_rho=pn_rho;
TheArray.pm=pm_rho;
TheArray.pn=pn_rho;
TheArray.mn_rho=mn_rho;
TheArray.mn_psi=mn_psi;
%
KlandPsi=find(MSK_psi == 0);
KseaPsi=find(MSK_psi == 1);
KlandRho=find(MSK_rho == 0);
KseaRho=find(MSK_rho == 1);
KlandU=find(MSK_u == 0);
KseaU=find(MSK_u == 1);
KlandV=find(MSK_v == 0);
KseaV=find(MSK_v == 1);
TheArray.KlandPsi=KlandPsi;
TheArray.KseaPsi=KseaPsi;
TheArray.KlandRho=KlandRho;
TheArray.KseaRho=KseaRho;
TheArray.KlandU=KlandU;
TheArray.KseaU=KseaU;
TheArray.KlandV=KlandV;
TheArray.KseaV=KseaV;
%
SigSize=[num2str(eta_rho) 'x' num2str(xi_rho)];
TheArray.SigSize=SigSize;
%
LONnorth_u=LON_u(eta_u,:);
LONsouth_u=LON_u(1,:);
LONwest_u=LON_u(:,1);
LONeast_u=LON_u(:,xi_u);
LATnorth_u=LAT_u(eta_u,:);
LATsouth_u=LAT_u(1,:);
LATwest_u=LAT_u(:,1);
LATeast_u=LAT_u(:,xi_u);
ANGnorth_u=ANG_u(eta_u,:);
ANGsouth_u=ANG_u(1,:);
ANGwest_u=ANG_u(:,1);
ANGeast_u=ANG_u(:,xi_u);
LONnorth_v=LON_v(eta_v,:);
LONsouth_v=LON_v(1,:);
LONwest_v=LON_v(:,1);
LONeast_v=LON_v(:,xi_v);
LATnorth_v=LAT_v(eta_v,:);
LATsouth_v=LAT_v(1,:);
LATwest_v=LAT_v(:,1);
LATeast_v=LAT_v(:,xi_v);
ANGnorth_v=ANG_v(eta_v,:);
ANGsouth_v=ANG_v(1,:);
ANGwest_v=ANG_v(:,1);
ANGeast_v=ANG_v(:,xi_v);
%
LONbound=GRID_GetBound(LON_rho);
LATbound=GRID_GetBound(LAT_rho);
TheArray.LONbound=LONbound;
TheArray.LATbound=LATbound;
%
nbWetRho=size(KseaRho,1);
nbWetPsi=size(KseaPsi,1);
nbWetU=size(KseaU,1);
nbWetV=size(KseaV,1);
nbWetUV=nbWetU+nbWetV;
TheArray.nbWetRho=nbWetRho;
TheArray.nbWetPsi=nbWetPsi;
TheArray.nbWetU=nbWetU;
TheArray.nbWetV=nbWetV;
TheArray.nbWetUV=nbWetUV;
TheArray.xy_rho=nbWetRho;
TheArray.xy_u=nbWetU;
TheArray.xy_v=nbWetV;
TheArray.xy_psi=nbWetPsi;
%
[LON_psi2, LAT_psi2, MSK_psi2, DEP_psi2]=GRID_ExtendedPsiThi(...
    MSK_rho, LON_rho, LAT_rho, LON_psi, LAT_psi, ...
    LON_u, LAT_u, LON_v, LAT_v, ...
    DEP_rho, DEP_u, DEP_v, DEP_psi);
TheArray.LON_psi2=LON_psi2;
TheArray.LAT_psi2=LAT_psi2;
TheArray.MSK_psi2=MSK_psi2;
TheArray.DEP_psi2=DEP_psi2;
%
MinLon=min(LON_rho(KseaRho));
MaxLon=max(LON_rho(KseaRho));
MinLat=min(LAT_rho(KseaRho));
MaxLat=max(LAT_rho(KseaRho));
TheArray.MinLon=MinLon;
TheArray.MaxLon=MaxLon;
TheArray.MinLat=MinLat;
TheArray.MaxLat=MaxLat;
TheArray.TheQuad=[MinLon MaxLon MinLat MaxLat];
%
LONsel=LON_rho(:,xi_rho);
LATsel=LAT_rho(:,xi_rho);
MinLonEast=min(LONsel);
MaxLonEast=max(LONsel);
MinLatEast=min(LATsel);
MaxLatEast=max(LATsel);
TheArray.TheQuadEast=[MinLonEast MaxLonEast MinLatEast MaxLatEast];
MSKeast=MSK_rho(:,xi_rho);
Keast=find(MSKeast == 1);
nbEast=size(Keast,1);
TheArray.nbEast=nbEast;
TheArray.TheQuadEastRed=[min(LONsel(Keast)) max(LONsel(Keast)) ...
		    min(LATsel(Keast)) max(LATsel(Keast))];
%
MinLonWest=min(LON_rho(:,1));
MaxLonWest=max(LON_rho(:,1));
MinLatWest=min(LAT_rho(:,1));
MaxLatWest=max(LAT_rho(:,1));
TheArray.TheQuadWest=[MinLonWest MaxLonWest MinLatWest MaxLatWest];
MSKwest=MSK_rho(:,1);
Kwest=find(MSKwest == 1);
nbWest=size(Kwest,1);
TheArray.nbWest=nbWest;
%
MinLonNorth=min(LON_rho(eta_rho,:));
MaxLonNorth=max(LON_rho(eta_rho,:));
MinLatNorth=min(LAT_rho(eta_rho,:));
MaxLatNorth=max(LAT_rho(eta_rho,:));
TheArray.TheQuadNorth=[MinLonNorth MaxLonNorth MinLatNorth MaxLatNorth];
MSKnorth=MSK_rho(eta_rho,:);
Knorth=find(MSKnorth == 1);
nbNorth=size(Knorth,1);
TheArray.nbNorth=nbNorth;
%
MinLonSouth=min(LON_rho(1,:));
MaxLonSouth=max(LON_rho(1,:));
MinLatSouth=min(LAT_rho(1,:));
MaxLatSouth=max(LAT_rho(1,:));
MSKsouth=MSK_rho(1,:);
Ksouth=find(MSKsouth == 1);
nbSouth=size(Ksouth,1);
KseaRhoSouth=find(LON_rho >= MinLonSouth & LON_rho <= MaxLonSouth & ...
		  LAT_rho >= MinLatSouth & LAT_rho <= MaxLatSouth & ...
		  MSK_rho == 1);
TheArray.TheQuadSouth=[MinLonSouth MaxLonSouth MinLatSouth MaxLatSouth];
TheArray.nbSouth=nbSouth;
TheArray.KseaRhoSouth=KseaRhoSouth;
%
[str1, str2, str3, str4, ...
 str5, str6, str7, str8]=GRID_GetEWNSinfo(MSK_rho);
TheArray.str1=str1;
TheArray.str2=str2;
TheArray.str3=str3;
TheArray.str4=str4;
TheArray.str5=str5;
TheArray.str6=str6;
TheArray.str7=str7;
TheArray.str8=str8;
%
TheRecMSK=GRID_GetBoundaryMasks(MSK_rho);
TheArray.KsouthSelect=TheRecMSK.KsouthSelect;
TheArray.KnorthSelect=TheRecMSK.KnorthSelect;
TheArray.KwestSelect=TheRecMSK.KwestSelect;
TheArray.KeastSelect=TheRecMSK.KeastSelect;
