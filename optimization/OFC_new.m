function [M] = OFC_new( x,classL,cameraL,M1,M2,M3,L,lambda0,lambda1,flag ,Dist)
Lip=20;
rho=1.7;
tol=1e+1;
iter_in = 1;
Mopt = M1;
Mvar1 = M2;
Mvar2 = M3;
S=Mopt;M=Mopt;Pre_M=Mopt;
switch flag
    case 1
        varseq = [S,Mvar1,Mvar2];
    case 2
        varseq = [Mvar1,S,Mvar2];
    case 3
        varseq = [Mvar1,Mvar2,S];
end

t=1;

while iter_in<=5
    disp(['iter_in',num2str(iter_in)])
    distance  = cdistance( x,cameraL,varseq,Dist );
    fs=cf(x,classL,varseq,L,lambda0,lambda1,flag,distance);
    gfs=cgf(x,classL,varseq,L,lambda0,lambda1,flag,Dist,distance );
    rho=rho/1.1;
    k=0;
    while k<5
        M=S-gfs/rho;
        M=(M+M')/2.0;
        [V,D]=eig(M);
        r=find(diag(D)>0);
        M=V(:,r)*D(r,r)*V(:,r)';
        
        distance  = cdistance( x,cameraL,M,Mvar1,Mvar2,Dist );
        fm=cf( x,classL,M,Mvar1,Mvar2,L,lambda0,lambda1,flag,distance);
        if fm<=(fs+trace(gfs'*(M-S))+0.5*rho*(norm(M-S,'fro')^2))
            break;
        else
            rho=min(2*rho,Lip);
        end
        k=k+1;
        disp(['iter_in',num2str(iter_in),'  k',num2str(k)])
    end
    
    tt=(1+sqrt(1+4*t*t))/2.0;
    S=M+(t-1)*(M-Pre_M)/tt;
    t=tt;
    
    if norm(Pre_M-M,'fro')<tol
        break;
    end
    Pre_M=M;
    iter_in = iter_in +1;
end

end
