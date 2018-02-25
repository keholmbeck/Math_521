clear;

A = [1  1  1  1
      0  1  0  1
      0  1  0  1
      0  1  0  1
      1  1  1  1];

[U,S,V] = svd(A);

for k = 1:4
    Ak{k} = rank_k_approx(U,S,V,k);
end

% sprintf for LaTeX generation
for k = 1:length(Ak)
    str = sprintf('A_%d &= \\begin{bmatrix} ', k);
    tmp = Ak{k};
    for ii = 1:size(tmp,1)
        for jj = 1:size(tmp,2)
            val = tmp(ii,jj);
            
            if abs(val)<1e-10
                str = [str, sprintf('\\epsilon')];
            else
                str = [str, sprintf('%g', val) ];
            end
            
            if jj < size(tmp,2)
                str = [str, ' && '];
            end
        end
        if ii < size(tmp,1)
            str = [str, sprintf('\\\\ \n')];
        end
    end
    str = [str, sprintf('\\end{bmatrix} \\\\ ')];
    disp(str);
end

A_rank_norms = cellfun(@(x) norm(A-x), Ak);

g = colormap('gray');
g = g(end:-1:1, :);

CAX = [min(cellfun(@(x) min(x(:)), Ak)), max(cellfun(@(x) max(x(:)), Ak))];
for ii = 1:length(Ak)
    % subplot(length(Ak), 1, ii);
    h = disp_pattern(Ak{ii});
    title(sprintf('A_%d',ii), 'FontW', 'B');
    axis image; axis off;
    caxis(CAX); colormap(g);
    if ii == 1
        colorbar;
    end
    saveas(gcf, sprintf('data/Prob2_%d.png',ii));
end
