clear;clc;
str = 'C:\Users\LambertShi\Desktop\temp\VIPeR';
pt = dir(str);
numOfimg = length(pt)-1;

for i=3:numOfimg
    tempname = pt(i).name;
    namestr = strcat( str,'\',tempname);
    if mod(i,2)==1
    cameraimg{ceil(i/2-1),1} = im2double(imread(namestr));
    else
    cameraimg{ceil(i/2-1),2} = im2double(imread(namestr));
    end
end
save cameraimg;