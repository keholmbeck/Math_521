clear;

rng(1028);

GEN_PLOTS = false;

N = 3;
M = 64;     % size of spatial grid
P = 64;     % number of points in the ensemble

xm = ((1:M)-1)* 2*pi / M;
tm = ((1:P)-1)* 2*pi / P;

[T,X] = meshgrid(tm, xm);

f    = zeros(M,P);
mask = ones(M,P);        % known mask for gappy data
k    = ceil(0.10*M);     % 0.10 of indices will be gappy

for ii = 1:N
    f = f + sin(ii*(X-T))/ii;
end
for ii = 1:P
    ndx = randperm(M, k);
    mask(ndx,ii) = 0;
end
mask = logical(mask);

xt = f / N;         % true data
xg = xt.*mask;      % gappy data

[xrep, eigData] = repair_gappy_data(xg, mask);

markers = {'o', '+', '*', 'd', 's', '^', 'V', '>', '<'};

if GEN_PLOTS
    surf(xt, 'EdgeColor','none');
    axis tight; title 'True Data' FontW B; xlabel x; ylabel y;
    saveas(gcf, 'data/true_data.png');
    
    surf(xg, 'EdgeColor','none');
    axis tight; title 'Gappy Data' FontW B; xlabel x; ylabel y;
    saveas(gcf, 'data/gappy_data.png');
    
    [U,S,V] = svd(xrep, 0);
    for jj = 1:2
        for ii = 1:5
            plot(U(:,ii*jj), markers{ii}); hold on;
        end
        hold off;
        if jj == 1
            title 'First 5 eigenvectors' 'FontW' B;
        else
            title 'Second 5 eigenvectors' 'FontW' B;
        end
        saveas(gcf, sprintf('data/eigvec_%d.png', jj));
    end
    
    nIter = size(eigData,1);
    for ii = 1:nIter
        subplot(4,2,2*ii-1);
        surf(eigData{ii,3}, 'EdgeColor', 'none');
        axis tight;
        
        if ii == 1
            title({'Approximated Data', sprintf('iter %d',ii)}, 'FontW','B');
        else
            title(sprintf('iter %d',ii), 'FontW','B');
        end
        
        subplot(4,2,2*ii);
        surf(xt - eigData{ii,3}, 'EdgeColor', 'none');
        axis tight;
        if ii == 1
            title({'Error', sprintf('iter %d',ii)}, 'FontW','B');
        else
            title(sprintf('iter %d',ii), 'FontW','B');
        end
    end
    
    % already knowing nIterations = 8 ---
    for ii = 1:nIter
        subplot(4,2,ii);
        plot(eigData{ii,1}); axis tight;
        title(sprintf('iteration %d', ii));
    end
    saveas(gcf, 'data/eigvec_convergence.png');
    
    eigVals = cell2mat(eigData(:,2)');
    evDiff  = diff(eigVals');
    plot(2:8, evDiff); axis tight;
    xlabel iteration; ylabel 'difference from previous iteration';
    title 'Convergence of eigenvalues' FontW B;
    saveas(gcf, 'data/eigval_convergence.png');
end
