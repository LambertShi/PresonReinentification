function [ sumgz ] = clogz( x,distance)
numOfpoint = size(x,2);
sumgz = 0;
for flag = 1:numOfpoint
    sumz = 0;
    for i=1:numOfpoint
        if i==flag
            continue;
        end
        sumz=sumz+exp(- distance(flag,i));
    end
    sumgz = sumgz+ log(sumz);
end
end