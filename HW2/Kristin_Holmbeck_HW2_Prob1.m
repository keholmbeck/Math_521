clear;

A4 = [1  1  1  1
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

A1 = [1  1  1  1
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
end

for ii = 1:3
    subplot(1,3,ii); imagesc(Adisp{ii}); axis image; axis off; grid off;
    colormap(g);
end
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1),pos(2), 866,295]);
saveas(gcf, 'data/kohonen_training.png');

close all;
imagesc(Adisp{4}); axis image; axis off; grid off; colormap(g);
saveas(gcf, 'data/pattern.png');

imagesc(Adisp{5}); axis image; axis off; grid off; colormap(g);
saveas(gcf, 'data/novelty.png');
