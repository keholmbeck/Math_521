function newImg = translateH(img, tx)

[nr, nc] = size(img);
newImg = zeros(nr, nc);

if tx > 0
    newImg(:,(tx+1):end) = img(:,1:(end-tx));
else
    newImg(:,1:(end+tx)) = img(:,(abs(tx)+1):end);
end

end
