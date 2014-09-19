epoch = 1;
meanacc = zeros(1,20);
addpath('..\')
addpath('.\optimization\')
load viper.mat
while epoch<=size(GallarySampleIndexOrderMatrix,1)
disp(epoch)
numOfpair = size(FeatureSetC,2)/2;
totalIndex = 0:numOfpair-1;
GallaryIndex = 2*totalIndex+GallarySampleIndexOrderMatrix(epoch,:);
GallaryImg = FeatureSetC(:,GallaryIndex);

totalIndex = 1:size(FeatureSetC,2);
totalIndex(GallaryIndex) = [];
ProbeIndex = totalIndex;
ProbeImg = FeatureSetC(:,ProbeIndex);
numOftest = 316;

testIndex = sort(randperm(numOfpair,numOftest));
totalIndex = 1:numOfpair;
totalIndex(testIndex) = [];
trainIndex = totalIndex;

camera1trainfea = GallaryImg(:,trainIndex);
camera2trainfea = ProbeImg(:,trainIndex);
camera1testfea = GallaryImg(:,testIndex);
camera2testfea = ProbeImg(:,testIndex);
trainmeanimg = mean([camera1trainfea,camera2trainfea]');
save('fea.mat','camera1trainfea','camera2trainfea','trainmeanimg',...
    'camera1testfea','camera2testfea','trainIndex','testIndex');


% pca dimension reduction
dimension = 50;
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
epsilon = 2e1;
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

%test
camera1testfea = camera1testfea - repmat(trainmeanimg',1,size(camera1testfea,2));
camera2testfea = camera2testfea - repmat(trainmeanimg',1,size(camera2testfea,2));
camera1testfea = ProMatrix'*camera1testfea;
camera2testfea = ProMatrix'*camera2testfea;

topn = 20;
ResultIndex = zeros(size(camera1testfea,2),topn);
for i=1:size(camera1testfea,2)
    	[a,b] = sort(computeDistance(camera1testfea(:,i),camera2testfea,M1,M2,M3));
%     [a,b] = sort(computeDistance1(camera1testfea(:,i),camera2testfea,M1,M2,M3));
    ResultIndex(i,:) = b(1:topn);
end

fs = fopen('result.txt', 'a+');
fprintf(fs,sprintf( '\r\n***** results of dimnesion %d *****\r\n', dimension));
ClassLabel = [1:size(camera1testfea,2)]';
TestSampleAmount = size(camera1testfea,2);
for rank = 1 : topn
    Temp = ResultIndex(:,1 : rank) == ClassLabel * ones(1,rank);
    Rank1cAccRate = sum(sum(Temp==1,1)) / TestSampleAmount;
    disp(['MatchingRate for Rank ' num2str(rank) ' is ' num2str(Rank1cAccRate*100) ' %']);
    fprintf(fs,sprintf('MatchingRate for Rank %d is %f \r\n', rank,Rank1cAccRate*100));
    acc(1,rank) = Rank1cAccRate;
end
meanacc = meanacc + acc;
fclose(fs);
epoch = epoch+1;
end
