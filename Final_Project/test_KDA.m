clear;

rng(1);
n1 = 250;
n2 = 300;

folder = 'tex/kda_test/';
fname   = 'parab';

newfig = figure;
fullPos = get(gca, 'Position');

switch fname
    case 'parab'      % parabola data
        x = 0.5*randn(1,n1);
        y = 0.5*randn(1,n1) + 10;

        x1 = linspace(-3,2,n2) + randn(1,n2);
        y1 = x1.^2 + randn(1,n2);
    case 'circles'      % concentric circles data
        x = 1.5*randn(1,n1);
        y = 1.5*randn(1,n1);

        theta = linspace(0, 2*pi, n2);
        x1 = 10*cos(theta) + randn(1,n2);
        y1 = 10*sin(theta) + randn(1,n2);
    otherwise
        error('Invalid');
end

c1_style = 'ob';
c2_style = '.r';

figure;
axh = subplot(321);
ax1 = plot(x,y, c1_style); hold on;
ax2 = plot(x1,y1, c2_style, 'MarkerSize',10); hold off;
% axis tight;
XL = xlim; YL = ylim;

title 'Data'; 
h = legend([ax1(1),ax2(1)], 'Class 1', 'Class 2', 'Location', 'EastOutside');
pos = get(h, 'Position');
set(h,'Position', [pos(1)+0.2, pos(2), pos(3)+0.05, pos(4)+0.05]);

clf(newfig); h = copyobj(axh, newfig); set(h, 'Position', fullPos);
saveas(newfig, [folder, fname, '_data.png']);

DATA = [x, x1; y, y1];
classes = [zeros(1,n1), ones(1,n2)];

% Note: use the Gaussian kernel instead
[yproj0] = KLDA(DATA, classes, DATA);

c1 = (classes==0); c2 = (classes==1);

if max(yproj0(c1)) < max(yproj0(c2))
    alpha = max(yproj0(c1)) + min(yproj0(c2));
else
    alpha = min(yproj0(c1)) + max(yproj0(c2));
end
alpha = alpha / 2;

axh = subplot(323);
plot(x,y, c1_style);
hold on; plot(x1,y1, c2_style, 'MarkerSize',10); xlim(XL); ylim(YL);
hold off; title 'Kernel Separation';

clf(newfig); h = copyobj(axh, newfig); set(h, 'Position', fullPos);
saveas(newfig, [folder, 'KDA_', fname, '.png']);

axh = subplot(324);
plot(yproj0(c1),0, c1_style, 'MarkerSize',10); hold on;
plot(yproj0(c2),0, c2_style, 'MarkerSize',10);
plot(alpha*[1,1], 0.1*[-1,1], ':k', 'LineWidth',2);
hold off;
title 'Kernel Classification';

clf(newfig); h = copyobj(axh, newfig); set(h, 'Position', fullPos);
saveas(newfig, [folder, 'KDA_proj_', fname, '.png']);

opts.doPCA = false;
[yproj, yproj0, alpha, w] = LDA(DATA, classes, DATA, opts);

axh = subplot(325);
plot(x,y, c1_style);
hold on; plot(x1,y1, c2_style, 'MarkerSize',10);
slope = w(2)/w(1); xtmp = linspace(XL(1), XL(2), 100);
plot(xtmp, slope*xtmp, 'k');      % line that spans projection vector w
xlim(XL); ylim(YL);
hold off;
title 'LDA Separation'; figure(gcf);

clf(newfig); h = copyobj(axh, newfig); set(h, 'Position', fullPos);
saveas(newfig, [folder, 'LDA_', fname, '.png']);

axh = subplot(326);
plot(yproj0(c1),0, c1_style, 'MarkerSize',10); hold on;
plot(yproj0(c2),0, c2_style, 'MarkerSize',10);
plot(alpha*[1,1], 0.1*[-1,1], ':k', 'LineWidth',2);
hold off;
title 'LDA Classification';

clf(newfig); h = copyobj(axh, newfig); set(h, 'Position', fullPos);
saveas(newfig, [folder, 'LDA_proj_', fname, '.png']);