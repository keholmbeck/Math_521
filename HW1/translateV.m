function newImg = translateV(img, ty)

[nr, nc] = size(img);
nr2 = nr + abs(ty);
newImg = zeros(nr2, nc);

if ty > 0
    newImg((ty+1):end,:) = img;
else
    newImg(1:(end+ty),:) = img;
end


end
