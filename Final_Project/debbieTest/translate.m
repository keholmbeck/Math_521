function [newImg] = translate(Img,tx,ty)
% Convert image to grayscale is necessary.
if size(Img,3) == 3
    Img = rgb2gray(Img);
end
Img = double(Img);

[N, M] = size(Img);
[x,y]= meshgrid(1:M, 1:N);

x_new = x(:)' + tx;
y_new = y(:)' + ty;

newImg = interp2(x,y,Img, x_new, y_new, 'linear',255);
newImg = reshape(newImg, N, M);