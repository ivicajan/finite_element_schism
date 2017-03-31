function [jdx1, jdx2, jdx3]=TRIG_Reorder(idx1, idx2, idx3)

jdx1=idx1;
jdx2=idx2;
jdx3=idx3;

if (jdx1 > jdx2)
  prov=jdx1;
  jdx1=jdx2;
  jdx2=prov;
end;
if (jdx1 > jdx3)
  prov=jdx1;
  jdx1=jdx3;
  jdx3=prov;
end;
if (jdx2 > jdx3)
  prov=jdx2;
  jdx2=jdx3;
  jdx3=prov;
end;
