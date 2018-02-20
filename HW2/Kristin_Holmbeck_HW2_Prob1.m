clear;

A1 = [1  1  1  1
      0  1  0  1
      0  1  0  1
      0  1  0  1
      1  1  1  1];

A2 = [1  1  1  1
      1  0  0  1
      1  0  0  1
      1  0  0  1
      1  1  1  1];

A3 = [1  1  1  1
      0  0  0  1
      0  0  0  1
      0  0  0  1
      1  1  1  1];

A4 = [1  1  1  1
      0  0  0  0
      0  0  0  0
      0  0  0  0
      1  1  1  1];

% find an orthonormal basis for the first 3 patterns
W = [A1, A2, A3];
W = [A1(:), A2(:), A3(:)];
W = orth(W);

% Obtain the projection matrix P
P = W*W';
x = A4(:);

% the orthogonal complement is (I-P)x
w = P*x;
wt = (eye(size(P,1)) - P)*x;


subplot(221); imagesc(-A1); axis image; grid off;
subplot(222); imagesc(-A2); axis image; grid off;
subplot(223); imagesc(-A3); axis image; grid off;
subplot(224); imagesc(-A4); axis image; grid off;
colormap gray;


