function [M] = OFC( x,classL,cameraL,M1,M2,M3,L,lambda0,lambda1,flag ,Dist)
Lip=20;
rho=1.7;
tol=1e+1;
iter_in = 1;
if flag==1
    S=M1;M=M1;Pre_M=M1;
    t=1;
    while iter_in<=5
        disp(['iter_in',num2str(iter_in)])
        distance  = cdistance( x,cameraL,S,M2,M3,Dist );
        fs=cf(x,classL,S,M2,M3,L,lambda0,lambda1,flag,distance);
        gfs=cgf(x,classL,S,M2,M3,L,lambda0,lambda1,flag,Dist,distance );
        rho=rho/1.1;
        k=0;
        while k<5
            M  = psdProjection( S,gfs,rho );
            distance  = cdistance( x,cameraL,M,M2,M3,Dist );
            fm=cf( x,classL,M,M2,M3,L,lambda0,lambda1,flag,distance);
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
%%
if flag==2
    S=M2;M=M2;Pre_M=M2;
    t=1;
    while iter_in<5
        disp(['iter_in',num2str(iter_in)])
        distance  = cdistance( x,cameraL,M1,S,M3,Dist );
        fs=cf( x,classL,M1,S,M3,L,lambda0,lambda1,flag,distance);
        gfs=cgf( x,classL,M1,S,M3,L,lambda0,lambda1,flag ,Dist,distance );
        rho=rho/1.1;
        k=0;
        while k<5
            M  = psdProjection( S,gfs,rho );
            distance  = cdistance( x,cameraL,M1,M,M3,Dist );
            fm=cf( x,classL,M1,M,M3,L,lambda0,lambda1,flag,distance);
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
if flag==3
    S=M3;M=M3;Pre_M=M3;
    t=1;
    while iter_in<5
        disp(['iter_in',num2str(iter_in)])
        distance  = cdistance( x,cameraL,M1,M2,S,Dist );
        fs=cf( x,classL,M1,M2,S,L,lambda0,lambda1,flag,distance);
        gfs=cgf( x,classL,M1,M2,S,L,lambda0,lambda1,flag,Dist,distance  );
        rho=rho/1.1;
        k=0;
        while k<5
            M  = psdProjection( S,gfs,rho );
            distance  = cdistance( x,cameraL,M1,M2,M,Dist );
            fm=cf(x,classL,M1,M2,M,L,lambda0,lambda1,flag,distance);
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
end