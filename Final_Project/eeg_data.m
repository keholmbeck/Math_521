clear;

foldername = 'data/EEG_for_FDA/';
files = dir(foldername);
files = files(3:end);

task    = [0,2,3];
trials  = 0:9;
ntrials = length(trials);
[CLASS_0, CLASS_2, CLASS_3] = deal( [] );

siz = [1040,19];

for c = task
    for trial = trials
        dat = load([foldername, sprintf('class-%d_seq-%d', c, trial)])';
        dat = dat(:);
        
        if c == 2
            CLASS_2 = [CLASS_2, dat];
        elseif c == 3
            CLASS_3 = [CLASS_3, dat];
        elseif c == 0
            try
            CLASS_0 = [CLASS_0, dat];
            catch
            end
        end
    end
end
rng(1028);
DATA    = [CLASS_2, CLASS_3];
classes = [ones(1,10), 2*ones(1,10)];
ndx     = (1:length(classes));
ndx     = randperm(length(classes));

[w, yproj, alpha] = LDA2(DATA(:,ndx), classes(ndx), DATA(:,ndx), 0.96);

% TrainData = DATA(:,ndx);
% % %{
% [w, yproj, alpha] = LDA(TrainData, classes(ndx), 0.96);
% yproj = KLDA(TrainData, classes(ndx), TrainData);

% yproj = w;
% [eigvector, eigvalue] = LDA_CAD(TrainData', classes(ndx)');
% w = eigvector; yproj = w'*TrainData;
% return
%}

ax1 = plot(yproj(classes(ndx)==1),0,'ob', 'MarkerSize',10); hold on;
ax2 = plot(yproj(classes(ndx)==2),0,'+r', 'MarkerSize',10);
plot(mean(yproj)*[1,1], 0.1*[-1,1], ':k', 'LineWidth',2); hold off; title LDA;
legend([ax1(1),ax2(1)], 'Class 1', 'Class 2');
figure(gcf);
