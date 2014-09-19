function [ sumd ] = cdd( x,classL,distance)
numOfpoint = size(x,2);
sumd = 0;
for i = 1:numOfpoint
    for j= i+1:numOfpoint
        if classL(i) == classL(j) 
            sumd = sumd + distance(i,j);
        end
    end
end
end