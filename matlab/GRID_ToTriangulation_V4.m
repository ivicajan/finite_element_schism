function ReturnInfo=GRID_ToTriangulation_V4(GrdArr)
    
% This program takes a GRID and returns a presumably consistent
% Finite Element triangulation
%
% ListTrig is the list of triangles (triples of integer numbers)
% ListNode is the list of coordinates (LON, LAT)
%
% ListBoundaryEdges is the list of edges on the boundary of the
% C-grid.

MSK_rho=GrdArr.MSK_rho;
LON_rho=GrdArr.LON_rho;
LAT_rho=GrdArr.LAT_rho;
DEP_rho=GrdArr.DEP_rho;
LON_psi2=GrdArr.LON_psi2;
LAT_psi2=GrdArr.LAT_psi2;
DEP_psi2=GrdArr.DEP_psi2;

LON_psi=GrdArr.LON_psi;
LAT_psi=GrdArr.LAT_psi;
DEP_psi=GrdArr.DEP_psi;

[eta_rho, xi_rho]=size(MSK_rho);
[eta_psi2, xi_psi2]=size(LON_psi2);
[eta_psi, xi_psi]=size(LON_psi);
disp(['eta_rho=' num2str(eta_rho) '  xi_rho=' num2str(xi_rho)]);
disp(['eta_psi=' num2str(eta_psi) '  xi_psi=' num2str(xi_psi)]);
disp(['eta_psi2=' num2str(eta_psi2) '  xi_psi2=' num2str(xi_psi2)]);

% 1 for rho
% 0 for psi

DoFirst=1;
DoSecond=1;
DoThird=1;
DoFourth=1;


UpperBoundTrig=eta_psi2*xi_psi2*8;

%
% first kind of triangles, stupid splitting of square in two triangles
%

nbTrig=0;
ListPTs=zeros(UpperBoundTrig, 3, 3);
ListBoundStatus=zeros(UpperBoundTrig, 3, 3);
MSK_rhoReduced=zeros(eta_rho-1, xi_rho-1);
MatNbHorizEdgeRR=zeros(eta_rho-1, xi_rho);
MatNbVertEdgeRR=zeros(eta_rho, xi_rho-1);
for iEta=2:eta_rho
  for iXi=2:xi_rho
    if (MSK_rho(iEta, iXi) == 1 && MSK_rho(iEta-1, iXi) == 1 && ...
	MSK_rho(iEta, iXi-1) == 1 && MSK_rho(iEta-1, iXi-1) == 1)
      MSK_rhoReduced(iEta-1, iXi-1)=1;
      %
      PT1=[1; iEta-1; iXi-1];
      PT2=[1; iEta-1; iXi];
      PT3=[1; iEta; iXi-1];
      if (DoFirst == 1)
	nbTrig=nbTrig+1;
	ListPTs(nbTrig, 1, :)=PT1;
	ListPTs(nbTrig, 2, :)=PT2;
	ListPTs(nbTrig, 3, :)=PT3;
      end;
      %
      PT1=[1; iEta; iXi];
      PT2=[1; iEta-1; iXi];
      PT3=[1; iEta; iXi-1];
      if (DoFirst == 1)
	nbTrig=nbTrig+1;
	ListPTs(nbTrig, 1, :)=PT1;
	ListPTs(nbTrig, 2, :)=PT2;
	ListPTs(nbTrig, 3, :)=PT3;
      end;
      MatNbHorizEdgeRR(iEta-1,iXi)=MatNbHorizEdgeRR(iEta-1,iXi)+1;
      MatNbHorizEdgeRR(iEta-1,iXi-1)=MatNbHorizEdgeRR(iEta-1,iXi-1)+1;
      MatNbVertEdgeRR(iEta-1,iXi-1)=MatNbVertEdgeRR(iEta-1,iXi-1)+1;
      MatNbVertEdgeRR(iEta,iXi-1)=MatNbVertEdgeRR(iEta,iXi-1)+1;
    end;
  end;
end;
disp('Main points written');

%
% Determination of the psi point that we do not take in the grid.
%

MSK_psiForbidden=zeros(eta_psi, xi_psi);
for iEta=1:eta_psi
  for iXi=1:xi_psi
    IsForbidden=0;
    if (MSK_rho(iEta, iXi) == 1 && MSK_rho(iEta+1, iXi+1) == 1 && ...
	MSK_rho(iEta,iXi+1) == 0 && MSK_rho(iEta+1,iXi) == 0)
      IsForbidden=1;
    end;
    if (MSK_rho(iEta, iXi) == 0 && MSK_rho(iEta+1, iXi+1) == 0 && ...
	MSK_rho(iEta,iXi+1) == 1 && MSK_rho(iEta+1,iXi) == 1)
      IsForbidden=1;
    end;
    if (IsForbidden == 1)
      MSK_psiForbidden(iEta, iXi)=1;
    end;
  end;
end;
disp('MSK_psiForbidden done');

%
% Second kind of triangles with one rho points and 2 psi points.
% 

MatNbHorizEdgePP=zeros(eta_psi-1, xi_psi);
MatNbVertEdgePP=zeros(eta_psi, xi_psi-1);
for iEta=1:eta_rho
  for iXi=1:xi_rho
    if (MSK_rho(iEta, iXi) == 1)
      if (iEta >= 2 && iEta <= eta_rho-1)
	if (iXi >= 2 && MSK_rho(iEta, iXi-1) == 0 && ...
	    MSK_psiForbidden(iEta-1,iXi-1) == 0 && ...
	    MSK_psiForbidden(iEta,iXi-1) == 0)
	  PT1=[1; iEta; iXi];
	  PT2=[0; iEta-1; iXi-1];
	  PT3=[0; iEta; iXi-1];
	  if (DoSecond == 1)
	    nbTrig=nbTrig+1;
	    ListPTs(nbTrig, 1, :)=PT1;
	    ListPTs(nbTrig, 2, :)=PT2;
	    ListPTs(nbTrig, 3, :)=PT3;
	  end;
	  MatNbHorizEdgePP(iEta-1,iXi-1)=1;
	end;
	if (iXi <= xi_rho-1 && MSK_rho(iEta, iXi+1) == 0 && ...
	    MSK_psiForbidden(iEta-1,iXi) == 0 && ...
	    MSK_psiForbidden(iEta,iXi) == 0)
	  PT1=[1; iEta; iXi];
	  PT2=[0; iEta-1; iXi];
	  PT3=[0; iEta; iXi];
	  if (DoSecond == 1)
	    nbTrig=nbTrig+1;
	    ListPTs(nbTrig, 1, :)=PT1;
	    ListPTs(nbTrig, 2, :)=PT2;
	    ListPTs(nbTrig, 3, :)=PT3;
	  end;
	  MatNbHorizEdgePP(iEta-1,iXi)=1;
	end;
      end;
      if (iXi >= 2 && iXi <= xi_rho-1)
	if (iEta >= 2 && MSK_rho(iEta-1, iXi) == 0 && ...
	    MSK_psiForbidden(iEta-1,iXi-1) == 0 && ...
	    MSK_psiForbidden(iEta-1,iXi) == 0)
	  PT1=[1; iEta; iXi];
	  PT2=[0; iEta-1; iXi-1];
	  PT3=[0; iEta-1; iXi];
	  if (DoSecond == 1)
	    nbTrig=nbTrig+1;
	    ListPTs(nbTrig, 1, :)=PT1;
	    ListPTs(nbTrig, 2, :)=PT2;
	    ListPTs(nbTrig, 3, :)=PT3;
	  end;
	  MatNbVertEdgePP(iEta-1,iXi-1)=1;
	end;
	if (iEta <= eta_rho-1 && MSK_rho(iEta+1, iXi) == 0 && ...
	    MSK_psiForbidden(iEta,iXi-1) == 0 && ...
	    MSK_psiForbidden(iEta,iXi) == 0)
	  PT1=[1; iEta; iXi];
	  PT2=[0; iEta; iXi-1];
	  PT3=[0; iEta; iXi];
	  if (DoSecond == 1)
	    nbTrig=nbTrig+1;
	    ListPTs(nbTrig, 1, :)=PT1;
	    ListPTs(nbTrig, 2, :)=PT2;
	    ListPTs(nbTrig, 3, :)=PT3;
	  end;
	  MatNbVertEdgePP(iEta,iXi-1)=1;
	end;
      end;
    end;
  end;
end;
disp('Second kind of triangles created');


%
% Third kind of triangles with two rho points and 1 psi point.
% 
for iEta=1:eta_rho-1
  for iXi=1:xi_rho
    if (MatNbHorizEdgeRR(iEta, iXi) == 1)
      if (iXi >= 2 && iXi <= xi_rho-1 && ...
	  MSK_rhoReduced(iEta, iXi-1) == 1)
	PT1=[1; iEta; iXi];
	PT2=[1; iEta+1; iXi];
	PT3=[0; iEta; iXi];
	if (DoThird == 1)
	  nbTrig=nbTrig+1;
	  ListPTs(nbTrig, 1, :)=PT1;
	  ListPTs(nbTrig, 2, :)=PT2;
	  ListPTs(nbTrig, 3, :)=PT3;
	end;
      end;
      if (iXi <= xi_rho-1 && iXi >= 2 && ...
	  MSK_rhoReduced(iEta, iXi) == 1)
	PT1=[1; iEta; iXi];
	PT2=[1; iEta+1; iXi];
	PT3=[0; iEta; iXi-1];
	if (DoThird == 1)
	  nbTrig=nbTrig+1;
	  ListPTs(nbTrig, 1, :)=PT1;
	  ListPTs(nbTrig, 2, :)=PT2;
	  ListPTs(nbTrig, 3, :)=PT3;
	end;
      end;
    end;
  end;
end;
for iEta=1:eta_rho
  for iXi=1:xi_rho-1
    if (MatNbVertEdgeRR(iEta, iXi) == 1)
      if (iEta >= 2 && iEta <= eta_rho-1 && ...
	  MSK_rhoReduced(iEta-1, iXi) == 1)
	PT1=[1; iEta; iXi];
	PT2=[1; iEta; iXi+1];
	PT3=[0; iEta; iXi];
	if (DoThird == 1)
	  nbTrig=nbTrig+1;
	  ListPTs(nbTrig, 1, :)=PT1;
	  ListPTs(nbTrig, 2, :)=PT2;
	  ListPTs(nbTrig, 3, :)=PT3;
	end;
      end;
      if (iEta <= eta_rho-1 && iEta >= 2 && ...
	  MSK_rhoReduced(iEta, iXi) == 1)
	PT1=[1; iEta; iXi];
	PT2=[1; iEta; iXi+1];
	PT3=[0; iEta-1; iXi];
	if (DoThird == 1)
	  nbTrig=nbTrig+1;
	  ListPTs(nbTrig, 1, :)=PT1;
	  ListPTs(nbTrig, 2, :)=PT2;
	  ListPTs(nbTrig, 3, :)=PT3;
	end;
      end;
    end;
  end;
end;
disp('Third kind of triangles created');

%
% Fourth kind of triangles when we are far away from 
% the quadruple of wet rho points.
%

for iEta=1:eta_rho-1
  for iXi=1:xi_rho
    if (MSK_rho(iEta, iXi) == 1 && MSK_rho(iEta+1,iXi) == 1 && ...
	MatNbHorizEdgeRR(iEta, iXi) == 0)
      if (iXi >= 2)
	PT1=[1; iEta; iXi];
	PT2=[1; iEta+1; iXi];
	PT3=[0; iEta; iXi-1];
	if (DoFourth == 1)
	  nbTrig=nbTrig+1;
	  ListPTs(nbTrig, 1, :)=PT1;
	  ListPTs(nbTrig, 2, :)=PT2;
	  ListPTs(nbTrig, 3, :)=PT3;
	end;
      end;
      if (iXi <= xi_rho-1)
	PT1=[1; iEta; iXi];
	PT2=[1; iEta+1; iXi];
	PT3=[0; iEta; iXi];
	if (DoFourth == 1)
	  nbTrig=nbTrig+1;
	  ListPTs(nbTrig, 1, :)=PT1;
	  ListPTs(nbTrig, 2, :)=PT2;
	  ListPTs(nbTrig, 3, :)=PT3;
	end;
      end;
    end;
  end;
end;
for iEta=1:eta_rho
  for iXi=1:xi_rho-1
    if (MSK_rho(iEta,iXi) == 1 && MSK_rho(iEta,iXi+1) == 1 && ...
	MatNbVertEdgeRR(iEta, iXi) == 0)
      if (iEta >= 2)
	PT1=[1; iEta; iXi];
	PT2=[1; iEta; iXi+1];
	PT3=[0; iEta-1; iXi];
	if (DoFourth == 1)
	  nbTrig=nbTrig+1;
	  ListPTs(nbTrig, 1, :)=PT1;
	  ListPTs(nbTrig, 2, :)=PT2;
	  ListPTs(nbTrig, 3, :)=PT3;
	end;
      end;
      if (iEta <= eta_rho-1)
	PT1=[1; iEta; iXi];
	PT2=[1; iEta; iXi+1];
	PT3=[0; iEta; iXi];
	if (DoFourth == 1)
	  nbTrig=nbTrig+1;
	  ListPTs(nbTrig, 1, :)=PT1;
	  ListPTs(nbTrig, 2, :)=PT2;
	  ListPTs(nbTrig, 3, :)=PT3;
	end;
      end;
    end;
  end;
end;
disp('Fourth kind of triangles created');
disp(['nbTrig=' num2str(nbTrig)]);
ListPTsNew=ListPTs(1:nbTrig, 1:3, 1:3);
for iTrig=1:nbTrig
  for i=1:3
    if (ListPTsNew(iTrig, i, 1) == 0)
      ListPTsNew(iTrig,i,2)=ListPTsNew(iTrig,i,2)+1;
      ListPTsNew(iTrig,i,3)=ListPTsNew(iTrig,i,3)+1;
    end;
  end;
end;

ListPointStatus=GRID_GetBoundPointRP(ListPTsNew, GrdArr, 'rho');
TheRecord=TRIG_GetListNodeFromListPTijk(...
    ListPTsNew, ListPointStatus, GrdArr);
ReturnInfo.TheRecord=TheRecord;
%
% BUG: maybe we should have an analytic expression for the 
% ionterpolation arrays from the grid to the finite difference
% grid to the finite element grid and vice versa?
% This would gain in accuracy and speed.

