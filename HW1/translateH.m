function newImg = translateH(img, tx)

[nr, nc] = size(img);
nc2 = nc + abs(tx);
newImg = zeros(nr, nc2);

if tx > 0
    newImg(:,(tx+1):end) = img;
else
    newImg(:,1:(end+tx)) = img;
end

end
