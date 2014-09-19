function distvec = computeDistance1(im,imset,M1,M2,M3)

distvec = zeros(1,size(imset,2));
for i = 1:size(imset,2)
    im1 = M1*im;
    im2 = M2*imset(:,i);
    distvec(1,i) = trace(M3*(im1-im2)*(im1-im2)');
end

end

