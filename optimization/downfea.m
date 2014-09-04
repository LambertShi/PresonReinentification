function [ feamatrix , projectmatrix] = downfea( feamatrix, n )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[u,s,v] = svd(feamatrix);
projectmatrix = v(:,1:n);
% feamatrix = u*s*projectmatrix;
feamatrix = feamatrix*projectmatrix;
feamatrix = feamatrix';
end

