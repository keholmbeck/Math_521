clear;

clf;

load faces1.mat;

Y1 = double(Y1);
siz = [120,160];

Yavg = ensemble_average(Y1);
Yms = bsxfun(@minus, Y1, Yavg);

index = 50;
Yavg = reshape(Yavg, siz);
Yms_disp = reshape(Yms(:,index), siz);

imagesc(Yavg); axis image; colormap gray; title 'Ensemble Average';
axis off; saveas(gcf, 'data/ensemble_average.png');

subplot(121);
imagesc(reshape(Y1(:,index), siz)); axis image; colormap gray;
title(sprintf('%dth image',index), 'FontW','B');
axis off;

subplot(122);
imagesc(Yms_disp); axis image; colormap gray;
title(sprintf('%dth Mean-Subtracted image',index), 'FontW','B');
axis off;
saveas(gcf, 'data/mean_subtracted_ex.png');

[U,S,V] = best_basis(Y1);

% make some eigenpictures (from U)
clf;
for ii = 1:16
    jj = ii;
    if ii == 16
        jj = 50;
    end
    temp = map2uint8( U(:,jj) );
    temp = reshape(temp, siz);
    subplot(4,4,ii);
    imagesc(temp); title(sprintf('eig image %d', jj), 'FontW', 'B');
    axis image; colormap gray; axis off;
end
saveas(gcf, 'data/eig_images.png');


% reconstruct an image
clf;
E = cumulative_energy(diag(S), rank(Y1));
D = find(E>0.95,1);

ax(1) = plot(E,'.:'); title 'Cumulative Energy' FontW B;
hold on; ax(2) = plot(D, E(D),'or'); 
legend(ax(2), sprintf('index %d, %0.0f%% energy',D, 100*E(D)));
hold off; xlabel index; saveas(gcf, 'data/cumulative_energy.png');

lambda = diag(S).^2;
plot(lambda ./ lambda(1));
title 'Eigenvalues scaled by max(\lambda)' FontW B;
saveas(gcf, 'data/eigvals.png');

% Calculate the reconstruction error
imdiff  = 0*(D:rank(Y1));
ndx     = 0;

for P = D:rank(Y1)
    imrecon     = U(:,1:P) * S(1:P,1:P) * V(:,1:P)';
    imrecon     = reshape(imrecon(:,index), siz);
    imcom       = reshape(Yms(:,index), siz);
    tmp         = imcom - imrecon;
    ndx         = ndx + 1;
    imdiff(ndx) = norm(tmp);
end
