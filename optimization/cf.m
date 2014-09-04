function [sumall] = cf( x,classL,M1,M2,M3,L,lambda0,lambda1,flag ,distance)

[sumd ] = cdd( x,classL,distance);

[ sumz ] = clogz( x,distance );

[m,n]=size(M1);
gamma = L(2:size(L,1),1);
att = L(1,1);
if flag==1
     Mt=[reshape(M2,m*n,1),reshape(M3,m*n,1)];
     Bt=reshape(Mt*gamma,n,m);
     sumall=sumd+sumz+2*lambda0*trace(Bt*M1)+(lambda1+lambda0*att)*(norm(M1,'fro')^2);
end
if flag==2
     Mt=[reshape(M1,m*n,1),reshape(M3,m*n,1)];
     Bt=reshape(Mt*gamma,n,m);
     sumall=sumd+sumz+2*lambda0*trace(Bt*M2)+(lambda1+lambda0*att)*(norm(M2,'fro')^2);
end
if flag==3
     Mt=[reshape(M1,m*n,1),reshape(M2,m*n,1)];
     Bt=reshape(Mt*gamma,n,m);
     sumall=sumd+sumz+2*lambda0*trace(Bt*M3)+(lambda1+lambda0*att)*(norm(M3,'fro')^2);
end
end