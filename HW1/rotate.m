function newImg = rotate(img, theta, P)
% ROTATE
% 
% Syntax:
%   newImg = ROTATE(img, theta, P)
% 

M = [cos(theta),  -sin(theta), 0;
     sin(theta),   cos(theta), 0;
     0,             0,         1];

[nr,nc] = size(img);
[xs,ys] = meshgrid(1:nc, 1:nr);

% Subtract the xs and ys by the point P, i.e. center the point P as the
% origin
xy_mat  = [xs(:)'-P(1); ys(:)'-P(2); ones(1,nr*nc)];

xyTrans = M*xy_mat;

xi = reshape(xyTrans(1,:), nr, nc);
yi = reshape(xyTrans(2,:), nr, nc);

% Correct the point-P-at-the-origin while interp-ing
newImg = interp2(xs,ys, img, xi+P(1), yi+P(2));

end
