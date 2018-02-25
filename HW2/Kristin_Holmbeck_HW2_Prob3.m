clear;

im = imread('data/testim.jpg');
im = double( rgb2gray(im) );

[U,S,V] = svd(im);
[U0,S0,V0] = svd(im, 0);

r = rank(im);

E = cumulative_energy(diag(S), r);
ind = find(E >=0.95, 1);

plot(E); ylabel 'cumulative energy'; xlabel index;
hold on; 
h = plot(ind, E(ind), 'or'); hold off;
legend(h, sprintf('95%% energy at index %d', ind), 'Location', 'E');
axis([-15, r+1, 0.89, 1.006]);
saveas(gcf, 'data/cumulative_energy.png');

ind = [95, 96, 97, 98, 99];
for ii = 1:length(ind);
    tmp = find(E*100 >= ind(ii), 1);
    
    A = rank_k_approx(U,S,V,tmp);
    A = uint8(A);
    imagesc(A); axis image; axis off; colormap gray;

    FILENAME = sprintf('data/rank_%d_approx.png', tmp);
    imwrite(A,  FILENAME);
end

n = 0;
for k = [10, 50, 100, 200]
    n = n + 1;
    A = rank_k_approx(U,S,V, k);
    A = uint8(A);
    
    subplot(2,2,n)
    imagesc(A); axis image; axis off; colormap gray;

    rel_err = S(k+1,k+1)/S(k,k);
    err_str = sprintf('\\sigma_{%d} / \\sigma_{%d} = %g', k+1, k, rel_err);
    title({sprintf('Rank-%d Approximation',k), err_str}, 'FontW', 'B');
end

