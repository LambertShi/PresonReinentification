function distvec = computeDistance(im,imset,M)

distvec = zeros(1,size(imset,2));
for i = 1:size(imset,2)
    distvec(1,i) = trace(M*(im-imset(:,i))*(im-imset(:,i))');
end

end


