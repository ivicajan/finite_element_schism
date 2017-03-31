function ListPointStatus=GRID_GetBoundPointRP(ListPTs, GrdArr, TheOpt)

[eta_rho, xi_rho]=size(GrdArr.LON_rho);
[eta_psi2, xi_psi2]=size(GrdArr.LON_psi2);

nbTrig=size(ListPTs, 1);
ListPointStatus=zeros(nbTrig,3);
%disp(['TheOpt=' TheOpt]);
for iTrig=1:nbTrig
  for i=1:3
    iCase=ListPTs(iTrig,i,1);
    iEta=ListPTs(iTrig,i,2);
    iXi=ListPTs(iTrig,i,3);
    eStatus=0;
    if (UTIL_IsStringEqual(TheOpt, 'rho') == 1)
      if (iCase == 0)
	if (iEta == 1 || iEta == eta_rho ...
	    || iXi == 1 || iXi == xi_rho)
	  eStatus=1;
	end;
      end;
    elseif (UTIL_IsStringEqual(TheOpt, 'psi2') == 1)
      if (iCase == 1)
	if (iEta == 1 || iEta == eta_psi2 ...
	    || iXi == 1 || iXi == xi_psi2)
	  eStatus=1;
	end;
      end;
    else
      disp('Put what you have in mind here');
      error('Please correct');
    end;
    ListPointStatus(iTrig,i)=eStatus;
  end;
end;
