function [ distance ] = cdistance( x,cameraL,M1,M2,M3,Dist )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
numOfpoint = size(x,2);
distance = zeros(numOfpoint);
for i = 1:numOfpoint
    for j= i+1:numOfpoint
        if cameraL(i) == cameraL(j)
            if cameraL(i) == 1
                M= M1;
            else
                M = M2;
            end
        else
            M = M3;
        end
        temp = Dist{i,j};
        distance(i,j) = temp'*M*temp;
        distance(j,i) = distance(i,j);
    end
end
end

