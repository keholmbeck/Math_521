clear;

load data/cats_and_dogs.mat
load data/PatternRecAns.mat

PREPROCESS = 1;

opts.doPCA    = 1;
opts.tol      = 0.95;
opts.kernType = 1;   % 0: polynomial, 1: RBF

plotOpts.c1_style = {'ob', 'MarkerSize', 10};
plotOpts.c2_style = {'+r', 'MarkerSize', 10};

if 0
    allNdx      = 1:size(DATA,2);
    trainNdx    = [1:77, 82:159];
    TrainData   = DATA(:,trainNdx);
    TrainClass  = classes( trainNdx );
    testNdx     = allNdx( ~ismember(allNdx,trainNdx) );
    TestSet     = DATA(:,testNdx);
    hiddenlabels= classes( testNdx );
else
    TrainData = DATA;
    TrainClass = classes;
end

if PREPROCESS
    %TrainData = addData(TrainData);
    
    if 1
        filtFcn = @waveletDecomp;
    else
        filtFcn = @(x,y)laplacianFilter(x);
    end
    TestSet = filtFcn(TestSet, 1);
    TrainData = filtFcn(TrainData, 1);
end

[Xproj, Xproj0, alpha] = LDA(TrainData, TrainClass, TestSet, opts);
[yproj, yproj0, wa] = KLDA(TrainData, TrainClass, TestSet, opts);

[pOpts1, pOpts2] = deal(plotOpts);
pOpts1.alpha = alpha;

alpha = mean(yproj0);
pOpts2.alpha = alpha;

% ----------------------------------------------
% plot the LDA
subplot(221);
[ax1, ax2] = plotClassification(Xproj0, TrainClass, pOpts1);
title 'LDA Training Data'; legend([ax1(1),ax2(1)], 'Cats', 'Dogs');

subplot(222);
[ax1, ax2] = plotClassification(Xproj, hiddenlabels, pOpts1);
title 'LDA Test Data'; legend([ax1(1),ax2(1)], 'Cats', 'Dogs');

% ----------------------------------------------
% plot the KDA
subplot(223);
[ax1, ax2] = plotClassification(yproj0, TrainClass, pOpts2);
title 'KDA Training Data'; legend([ax1(1),ax2(1)], 'Cats', 'Dogs');

subplot(224);
[ax1, ax2] = plotClassification(yproj, hiddenlabels, pOpts2);
title 'KDA Test Data'; legend([ax1(1),ax2(1)], 'Cats', 'Dogs');

figure(gcf);

% ----------------------------------------------
% Display classification rates
r = classification_rates(Xproj0, Xproj, TrainClass, hiddenlabels, pOpts1.alpha);
disp('LDA rate'); disp(r);

r = classification_rates(yproj0, yproj, TrainClass, hiddenlabels, pOpts2.alpha);
disp('KDA rate'); disp(r);
