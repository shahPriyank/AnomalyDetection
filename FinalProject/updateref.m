function Iref=updateref(Icurrent,vid)

Iref=Icurrent;
Iref=double(Iref);
[m n]=size(Iref);
for i=1:1:10
Icurrent=getdata(vid, 1); %getsnapshot
Icurrent=double(Icurrent);
%pause(0.1);
for j=1:1:m
for k=1:1:n
Iref(j,k)=double((Iref(j,k)+Icurrent(j,k))/2);
end
end
end

Iref=uint8(Iref);
