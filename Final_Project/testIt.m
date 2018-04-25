clear;

folder = 'TIFFtraining/';
files = dir( folder );
files = files(3:end);

DATA = [];
classes = zeros(1, length(files));

for ii = 1:length(files)
    fname = files(ii).name;
    dat = imread([folder, fname]);
    dat = dat(:,:,1);
    dat = dat(:);
    
    DATA = [DATA, dat];
    
    if ~isempty( strfind(lower(fname), 'cat') )
        classes(ii) = 1;
    else
        classes(ii) = 0;
    end
end
DATA = double(DATA);

[w, yproj, alpha] = LDA(DATA, classes);

subplot(121);
ndx = (classes == 0);
ax1 = plot(yproj(ndx),0,'ob', 'MarkerSize',10); hold on;
ax2 = plot(yproj(~ndx),0,'+r', 'MarkerSize',10);
plot(alpha*[1,1], 0.1*[-1,1], ':k', 'LineWidth',2); hold off; title LDA;
legend([ax1(1),ax2(1)], 'Dogs', 'Cats');

% LDA #2
P = load('PatternRecData.mat');
[w, yproj, alpha] = LDA(P.KLDATA(:,1:160), P.sublabels);

subplot(122);
ndx = (P.sublabels == 0);
ax1 = plot(yproj(ndx),0,'ob', 'MarkerSize',10); hold on;
ax2 = plot(yproj(~ndx),0,'+r', 'MarkerSize',10);
plot(alpha*[1,1], 0.1*[-1,1], ':k', 'LineWidth',2); hold off; title LDA;
legend([ax1(1),ax2(1)], 'Dogs', 'Cats');

