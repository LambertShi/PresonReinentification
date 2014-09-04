addpath('..\feaExtract\')
addpath('..\optimization\')
% load cameraimg.mat;
load fea.mat;
load M.mat;
load ProMatrix.mat;
camera1testfea = camera1testfea - repmat(trainmeanimg',1,size(camera1testfea,2));
camera2testfea = camera2testfea - repmat(trainmeanimg',1,size(camera2testfea,2));
camera1testfea = ProMatrix'*camera1testfea;
camera2testfea = ProMatrix'*camera2testfea;

topn = 20;
ResultIndex = zeros(size(camera1testfea,2),topn);
for i=1:size(camera1testfea,2)
    % 	[a,b] = sort(computeDistance(camera1testfea(:,i),camera2testfea,M3));
    [a,b] = sort(computeDistance1(camera1testfea(:,i),camera2testfea,M1,M2,M3));
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
end
fclose(fs);


