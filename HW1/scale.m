function newImg = scale(img, alpha, P)
% SCALE
% 
% Syntax:
%   newImg = SCALE(img, alpha, P)
% 
% with
%   point to scale around: P = [tx; ty; 1]
%   scaling size: alpha = [sx; sy]
% 

M = [alpha(1),  0,          (1-alpha(1))*P(1);
     0,         alpha(2),   (1-alpha(2))*P(2);
     0,         0,          1];

[nr,nc] = size(img);
[xs,ys] = meshgrid(1:nc, 1:nr);

xy_mat  = [xs(:)'; ys(:)'; ones(1,nr*nc)];

xyTrans = M*xy_mat;

xi = reshape(xyTrans(1,:), nr, nc);
yi = reshape(xyTrans(2,:), nr, nc);
newImg = interp2(xs,ys, img, xi, yi);

end
