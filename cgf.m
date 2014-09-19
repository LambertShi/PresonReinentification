function sumgall=cgf( x,classL,M1,M2,M3,L,lambda0,lambda1,flag,Dist,distance )
[ sumgd ] = cgd( x,classL,Dist);
[ sumgz ] = cglogz( x,Dist,distance );

[m,n]=size(M1);
gamma = L(2:size(L,1),1);
att = L(1,1);
if flag==1
    Mt=[reshape(M2,m*n,1),reshape(M3,m*n,1)];
    %      Bt=reshape(Mt*gamma,n,m);
    Bt=reshape(Mt*gamma,m,n)';
    sumgall=sumgd+sumgz+2*lambda0*Bt+2*(lambda1+lambda0*att)*M1;
end
if flag==2
    Mt=[reshape(M1,m*n,1),reshape(M3,m*n,1)];
    %     Bt=reshape(Mt*gamma,n,m);
    Bt=reshape(Mt*gamma,m,n)';
    sumgall=sumgd+sumgz+2*lambda0*Bt+2*(lambda1+lambda0*att)*M2;
end
if flag==3
    Mt=[reshape(M1,m*n,1),reshape(M2,m*n,1)];
    %     Bt=reshape(Mt*gamma,n,m);
    Bt=reshape(Mt*gamma,m,n)';
    sumgall=sumgd+sumgz+2*lambda0*Bt+2*(lambda1+lambda0*att)*M3;
end

end