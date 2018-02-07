function newImg = translateV(img, ty)

[nr, nc] = size(img);
newImg = zeros(nr, nc);

if ty > 0
    newImg(ty+1:end,:) = img(1:end-ty,:);
else
    newImg(1:(end+ty),:) = img(abs(ty)+1:end,:);
end

end
