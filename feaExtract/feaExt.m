load cameraimg.mat;
numOfpair = size(cameraimg,1);
numOftest = 316;
numOftrain = numOfpair - numOftest;
testIndex = sort(randperm(numOfpair,numOftest));
totalIndex = 1:numOfpair;
temp = totalIndex;
temp(testIndex) = [];
trainIndex = temp;

for i=1:numOftrain
    camera1trainfea(:,i) = feaExtration( cameraimg{trainIndex(i),1} );
    camera2trainfea(:,i) = feaExtration( cameraimg{trainIndex(i),2} );
    if mod(i,20)==0
        disp(i)
    end
end
for i=1:numOftest
    camera1testfea(:,i) = feaExtration( cameraimg{testIndex(i),1} );
    camera2testfea(:,i) = feaExtration( cameraimg{testIndex(i),2} );
    if mod(i,20)==0
        disp(i)
    end
end
 trainmeanimg = mean([camera1trainfea,camera2trainfea]');
 save('fea.mat','camera1trainfea','camera2trainfea','trainmeanimg',...
     'camera1testfea','camera2testfea','trainIndex','testIndex');

