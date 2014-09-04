addpath('..\feaExtract\')
load fea.mat;
% pca dimension reduction
dimension = 90;
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
iter_out = 0;
epsilon = 1e1;
while iter_out<10
    disp(['iter_out',num2str(iter_out)])
    disp('Optimization M1')
    [M1_new] = OFC( trainX,classL,cameraL,M1,M2,M3,L,lambda0,lambda1,1,Dist );
    disp('Optimization M2')
    [M2_new] = OFC( trainX,classL,cameraL,M1_new,M2,M3,L,lambda0,lambda1,2,Dist );
    disp('Optimization M3')
    [M3_new] = OFC( trainX,classL,cameraL,M1,M2_new,M3,L,lambda0,lambda1,3,Dist );
    
    disp([norm(M1_new-M1,'fro'),norm(M2_new-M2,'fro'),norm(M3_new-M3,'fro')])
    if norm(M1_new-M1,'fro')<epsilon && norm(M2_new-M2,'fro')<epsilon && norm(M3_new-M3,'fro')<epsilon
        break;
    else
        iter_out = iter_out + 1;      
    end
    M1 = M1_new;
    M2 = M2_new;
    M3 = M3_new;
end

save('M.mat','M1','M2','M3')
save('ProMatrix.mat','ProMatrix')
