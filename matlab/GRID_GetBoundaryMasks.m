function TheRecMSK=GRID_GetBoundaryMasks(MSK_rho)

[eta_rho, xi_rho]=size(MSK_rho);

MSK_south=MSK_rho(1, :);
MSK_north=MSK_rho(eta_rho, :);
MSK_west=MSK_rho(:, 1);
MSK_east=MSK_rho(:, xi_rho);

if (sum(MSK_south(:)) > 0)
  KsouthSelect=GRID_IntervalMaskSelection(MSK_south);
else
  KsouthSelect='irrelevant';
end;
if (sum(MSK_north(:)) > 0)
  KnorthSelect=GRID_IntervalMaskSelection(MSK_north);
else
  KnorthSelect='irrelevant';
end;
%
if (sum(MSK_west(:)) > 0)
  KwestSelect=GRID_IntervalMaskSelection(MSK_west);
else
  KwestSelect='irrelevant';
end;
if (sum(MSK_east(:)) > 0)
  KeastSelect=GRID_IntervalMaskSelection(MSK_east);
else
  KeastSelect='irrelevant';
end;
TheRecMSK.KsouthSelect=KsouthSelect;
TheRecMSK.KnorthSelect=KnorthSelect;
TheRecMSK.KwestSelect=KwestSelect;
TheRecMSK.KeastSelect=KeastSelect;
