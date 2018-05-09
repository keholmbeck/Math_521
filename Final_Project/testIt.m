clear;

load fisheriris.mat
uniqueClass = unique(species);
classes = cellfun(@(x) strcmp(x, uniqueClass(1)), species);
classes = classes + cellfun(@(x) 2*strcmp(x, uniqueClass(2)), species);

meas = meas(classes ~= 0, :);
classes = classes(classes ~= 0);

[w] = LDA_CAD(meas, classes);
% [w] = LDA(meas', classes');
yproj = meas*w;

ax1 = plot(yproj(classes==1),0,'ob', 'MarkerSize',10); hold on;
ax2 = plot(yproj(classes==2),0,'+r', 'MarkerSize',10);
hold off; title LDA; legend([ax1(1),ax2(1)], 'Dogs', 'Cats');
figure(gcf);

trainGda  =  gda(meas',meas',classes');