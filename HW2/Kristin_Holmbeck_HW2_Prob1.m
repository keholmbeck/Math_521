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
wt = reshape(wt, size(A4));

g = colormap('gray');
g = g(end:-1:1,:);

Adisp = {A1, A2, A3, A4, wt};
for jj = 1:length(Adisp)
    A = Adisp{jj};
    Z = zeros(2*size(A,1)+1, 2*size(A,2)+1);
    n = 0;
    for ii = 2:2:size(Z,2)
        n = n + 1;
        Z(2:2:end,ii) = A(:,n);
    end
    Adisp{jj} = Z;
    
    ax = subplot(2,3, jj);
    imagesc(Z); caxis([-1,1]);    
    axis image; axis off; grid off; colormap(g);
    
    if jj <= 3
        title(sprintf('Training Pattern %d', jj), 'FontW', 'B');
    elseif jj == 4
        title(sprintf('Pattern'), 'FontW', 'B');
    else
        title(sprintf('Novelty'), 'FontW', 'B');
    end
end
subplot(2,3,6); caxis([-1,1]); colorbar; axis off;

return

subplot(221); imagesc(-A1); axis image; grid off;
subplot(222); imagesc(-A2); axis image; grid off;
subplot(223); imagesc(-A3); axis image; grid off;
subplot(224); imagesc(-A4); axis image; grid off;
colormap gray;


