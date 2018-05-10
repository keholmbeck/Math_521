function [newImg] = rotate(Img, theta, P)
% theta in radians

% Convert image to grayscale is necessary.
if size(Img,3) == 3
    Img = rgb2gray(Img);
end
Img = double(Img);

[N, M] = size(Img);
tx = P(1); ty = P(2);

% form matrix of all the pts from the image in such ad such form
[x,y]= meshgrid(1:M, 1:N);
row_ones = ones(1,M*N);
xy_mat = [x(:)'; y(:)'; row_ones];

% rotation matrix
M_rot = [cos(theta), -sin(theta), (tx - tx*cos(theta) + ty*sin(theta));
         sin(theta),  cos(theta), (ty - tx*sin(theta) - ty*cos(theta));
         0 0 1];

% form new pts
xy_new = M_rot*xy_mat;

newImg = interp2(x,y,Img, xy_new(1,:), xy_new(2,:), 'linear',255);
newImg = reshape(newImg, N, M);