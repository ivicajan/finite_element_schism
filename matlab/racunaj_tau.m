function tau=racnaj_tau(out_C,time);
[m,n]=size(out_C);
flag=ones(1,n);
size(flag)
tau=NaN*flag;
for i=1:m;
for j=1:n
omjer=out_C(i,j)/100;
if(omjer<=1/2.7)&(flag(j))
tau(j)=time(i);flag(j)=0;
end
end
end
