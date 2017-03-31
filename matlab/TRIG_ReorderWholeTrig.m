function NewListTrig=TRIG_ReorderWholeTrig(ListTrig)

nbTrig=size(ListTrig,1);

NewListTrig=zeros(nbTrig, 3);

for iTrig=1:nbTrig
  i1=ListTrig(iTrig, 1);
  i2=ListTrig(iTrig, 2);
  i3=ListTrig(iTrig, 3);
  [a1, a2, a3]=TRIG_Reorder(i1, i2, i3);
  NewListTrig(iTrig, :)=[a1, a2, a3];
end;
