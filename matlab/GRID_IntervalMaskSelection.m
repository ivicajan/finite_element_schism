function TheK=GRID_IntervalMaskSelection(MSK_ofborder)

MSK_ofborderExp=MSK_ofborder(:);
len=size(MSK_ofborderExp, 1);

K=find(MSK_ofborderExp == 1);
TheK=min(K):max(K);

