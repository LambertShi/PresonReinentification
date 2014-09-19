function [ sumgd ] = cgd( x,classL,Dist)
[m,numOfpoint] = size(x);
sumgd = zeros(m,m);
for i = 1:numOfpoint
    for j= i+1:numOfpoint
        if classL(i) == classL(j)
            sumgd=sumgd+Dist{i,j}*Dist{i,j}';
        end
    end
end
end