function [ M ] = psdProjection( S,gfs,rho )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
            M=S-gfs/rho;
            M=(M+M')/2.0;
            [V,D]=eig(M);
            r=find(diag(D)>0);
            M=V(:,r)*D(r,r)*V(:,r)';

end

