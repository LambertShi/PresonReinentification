function [ sumgz ] = cglogz( x,Dist,distance)
numOfpoint = size(x,2);
sumgz = 0;
for flag = 1:numOfpoint
    sumzi = 0;
    sumgzi = 0;
    for i =1:numOfpoint
        if flag == i
            continue;
        end
        subz = exp(- distance(flag,i));
        sumgzi=sumgzi -subz*Dist{flag,i}*Dist{flag,i}';      
        sumzi=sumzi+subz;
    end
    sumgz = sumgz + sumgzi/sumzi;
end
end