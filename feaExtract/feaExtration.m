function [ fea_vec ] = feaExtration( orig_image )

[m,~] = size(orig_image);
stripeHeight = floor(m/6);
feamatrix = [];
for k = 1:6
    fea_matrix = [];
    rgb_image = orig_image((k-1)*stripeHeight+1:k*stripeHeight,:,:);
    %% 10 color feature extration
    ycbcr_image = im2double(rgb2ycbcr(rgb_image));
    hsv_image = im2double(rgb2hsv(rgb_image));
    
    for i=1:3
        [histogram, ~] = hist(reshape(rgb_image(:,:,i),[],1),16);
        fea_matrix = [fea_matrix; histogram];
    end
    for i=1:3
        [histogram, ~] = hist(reshape(ycbcr_image(:,:,i),[],1),16);
        fea_matrix = [fea_matrix; histogram];
    end
    for i=1:2
        [histogram, ~] = hist(reshape(hsv_image(:,:,i),[],1),16);
        fea_matrix = [fea_matrix; histogram];
    end
    %% 8 oritations gabor feature extration
    grayimg=im2double(rgb2gray(rgb_image));
    oritation = 90*[0,0,0,0,1,1,1,1];
    wavelength = [0.3,0.3,0.4,0.4,0.3,0.3,0.4,0.4];
    kx = [4,8,4,4,4,8,4,4];
    ky = [2,2,1,1,2,2,1,1];
    for i=1:8
        %[~,~,Aim]=spatialgabor(grayimg,3,oritation(i),0.5,0.5,0);%90-vertical===0-horizontal
        [~,~,Aim]=spatialgabor(grayimg,wavelength(i),oritation(i),kx(i),ky(i),0);
        [histogram, ~] = hist(reshape(Aim,[],1),16);
        fea_matrix = [fea_matrix; histogram];
    end
    %% 13 Schmid filters feature extration
    F = makeSfilters();
    for i=1:13
        schmidFea = conv2(grayimg,F(:,:,i),'same');
        [histogram, ~] = hist(reshape(schmidFea,[],1),16);
        fea_matrix = [fea_matrix; histogram];
    end
    feamatrix = [feamatrix , fea_matrix];
end
fea_vec = reshape(feamatrix',[],1);

end

