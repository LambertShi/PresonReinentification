function distvec = computeDistance(im,imset,M1,M2,M3)
M = (M1+M2+M3)/3;
distvec = zeros(1,size(imset,2));
for i = 1:size(imset,2)
    im1 = im;
    im2 = imset(:,i);
    distvec(1,i) = trace(M*(im1-im2)*(im1-im2)');
end

end


