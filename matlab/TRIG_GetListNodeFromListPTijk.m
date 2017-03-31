function TheRecord=TRIG_GetListNodeFromListPTijk(...
    ListPTs, ListPointStatus, GrdArr)
%
% this program output the grid from a synthetic grid obtained from
% a ROMS grid. It is hopefully extremely fast.
%

LON_rho=GrdArr.LON_rho;
LAT_rho=GrdArr.LAT_rho;
DEP_rho=GrdArr.DEP_rho;
LON_psi2=GrdArr.LON_psi2;
LAT_psi2=GrdArr.LAT_psi2;
DEP_psi2=GrdArr.DEP_psi2;

[eta_rho, xi_rho]=size(LON_rho);
[eta_psi2, xi_psi2]=size(LON_psi2);
nbTrig=size(ListPTs, 1);
disp(['nbTrig=' num2str(nbTrig)]);
ListKey=squeeze(ListPTs(:, :, 1)) + ...
	2*squeeze(ListPTs(:, :, 2)) + ...
	2*(eta_rho+2)*squeeze(ListPTs(:, :, 3));
ListKeyExp=ListKey(:);
ListKeyUnique=unique(ListKeyExp, 'rows');
disp('Unicitification operation finished');
nbNode=size(ListKeyUnique,1);
disp(['nbNode=' num2str(nbNode)]);
ListTrigExp=zeros(3*nbTrig,1);
ListNodeStatus=zeros(nbNode,1);
for iNode=1:nbNode
  eKey=ListKeyUnique(iNode,1);
  K=find(ListKeyExp == eKey);
  ListTrigExp(K)=iNode;
end;
disp('Renumbering finished');
ListTrig=reshape(ListTrigExp, nbTrig, 3);
%
ListNode=zeros(nbNode,2);
ListBathy=zeros(nbNode,1);
ListNodeStatus=zeros(nbNode,1);
ListStatusFinished=zeros(nbNode,1);
ListNodeNature=zeros(nbNode,3);
for iTrig=1:nbTrig
  for i=1:3
    iNode=ListTrig(iTrig, i);
    iCase=ListPTs(iTrig, i, 1);
    iEta=ListPTs(iTrig, i, 2);
    iXi=ListPTs(iTrig, i, 3);
    eStatus=ListPointStatus(iTrig,i);
    if (iCase == 1)
      eLon=LON_rho(iEta, iXi);
      eLat=LAT_rho(iEta, iXi);
      eDep=DEP_rho(iEta, iXi);
    else
      eLon=LON_psi2(iEta, iXi);
      eLat=LAT_psi2(iEta, iXi);
      eDep=DEP_psi2(iEta, iXi);
    end;
    ListNode(iNode,1)=eLon;
    ListNode(iNode,2)=eLat;
    ListNodeNature(iNode,1)=iCase;
    ListNodeNature(iNode,2)=iEta;
    ListNodeNature(iNode,3)=iXi;
    ListBathy(iNode,1)=eDep;
    ListNodeStatus(iNode,1)=eStatus;
    ListStatusFinished(iNode,1)=1;
  end;
end;
NewListTrig=TRIG_ReorderWholeTrig(ListTrig);

nbBound=0;
LS=[2,3,1];
ListBoundaryEdges=zeros(0,1);
for iTrig=1:nbTrig
  for i=1:3
    j=LS(1,i);
    iNode=ListTrig(iTrig,i);
    jNode=ListTrig(iTrig,j);
    if (ListNodeStatus(iNode,1) == 1 && ...
	ListNodeStatus(iNode,1) == 1)
      nbBound=nbBound+1;
      ListBoundaryEdges(nbBound,1)=iNode;
      ListBoundaryEdges(nbBound,2)=jNode;
    end;
  end;
end;
disp('Creation of ListNode, ListBathy finished');
K=find(ListStatusFinished == 0);
nbK=size(K,1);
disp(['nbK=' num2str(nbK)]);
disp(['nbBound=' num2str(nbBound)]);
TheRecord.nbTrig=nbTrig;
TheRecord.ListTrig=NewListTrig;
TheRecord.nbNode=nbNode;
TheRecord.ListNode=ListNode;
TheRecord.ListNodeNature=ListNodeNature;
TheRecord.ListBathy=ListBathy;
TheRecord.nbBound=nbBound;
TheRecord.ListNodeStatus=ListNodeStatus;
TheRecord.ListBoundaryEdges=ListBoundaryEdges;
disp('Reindexing operation finished');
