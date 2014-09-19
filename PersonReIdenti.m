addpath('..\feaExtract\')
load fea.mat;
% pca dimension reduction
dimension = 100;
trainX = [camera1trainfea, camera2trainfea];
trainX = trainX - repmat(trainmeanimg',1,size(trainX,2));
[ trainX , ProMatrix] = downfea( trainX',dimension);

% cameraLabel and classLabel
numOfclass1 = size(camera1trainfea,2);
numOfclass2 = size(camera2trainfea,2);
cameraL = [ones(1,numOfclass1),2*ones(1,numOfclass2)];
classL = [1:numOfclass1,1:numOfclass2];

% compute distance between every pair of training image
Dist = {};
for i = 1:size(trainX,2)
    for j = i:size(trainX,2)
        Dist{i,j} = trainX(:,i) - trainX(:,j);
        Dist{j,i} = Dist{i,j};
    end
end

% initial Mt must to be PSD
M1 =eye(size(trainX,1));
M2 =eye(size(trainX,1));
M3 =eye(size(trainX,1));
lambda0 =1;
lambda1 =1;
W = ones(3);
L = diag(sum(W,2))-W;
iter_out = 1;
epsilon = 1e1;
Mcell = {M1,M2,M3};
while iter_out<=10
    disp(['iter_out',num2str(iter_out)])
    Mcellold = Mcell;
    optorder = [1,1+randperm(2)];
    disp(['Optimization M',num2str(optorder(1))])
    Mcell{optorder(1)} = OFC( trainX,classL,cameraL, Mcell{1}, Mcell{2}, Mcell{3},L,lambda0,lambda1,optorder(1),Dist,epsilon );
    disp(['Optimization M',num2str(optorder(2))])
    Mcell{optorder(2)} = OFC( trainX,classL,cameraL, Mcell{1}, Mcell{2}, Mcell{3},L,lambda0,lambda1,optorder(2),Dist,epsilon );
    disp(['Optimization M',num2str(optorder(3))])
    Mcell{optorder(3)} = OFC( trainX,classL,cameraL, Mcell{1}, Mcell{2}, Mcell{3},L,lambda0,lambda1,optorder(3),Dist,epsilon );
    
    disp([norm(Mcell{1}-Mcellold{1},'fro'),norm(Mcell{2}-Mcellold{2},'fro'),norm(Mcell{3}-Mcellold{3},'fro')])
    if norm(Mcell{1}-Mcellold{1},'fro')<epsilon && norm(Mcell{2}-Mcellold{2},'fro')<epsilon && norm(Mcell{3}-Mcellold{3},'fro')<epsilon
        break;
    else
        iter_out = iter_out + 1;      
    end
end
M1 = Mcell{1};
M2 = Mcell{2};
M3 = Mcell{3};
save('M.mat','M1','M2','M3')
save('ProMatrix.mat','ProMatrix')
