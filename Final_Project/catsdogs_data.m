clear;

load data/cats_and_dogs.mat
load PatternRecAns.mat

GEN_FLIP_IM = 0;
PREPROCESS = 1;

folder = 'TIFFtraining/';
files = dir( folder );
files = files(3:end);

DATA = [];
classes = zeros(1, length(files));

PREPROCESS = 0;

for ii = 1:length(files)
    fname = files(ii).name;
    dat = imread([folder, fname]);
    dat = dat(:,:,1);
    dat0 = double(dat);
    
	if PREPROCESS
        % preprocess the data
        dat = imfilt(dat, 'average', [3,3]);
        dat = imfilt(dat, 'laplacian');
        dat = dat - dat0;
        
        dat = dat - min(dat(:));
        dat = dat ./ max(dat(:));
    end
    
    DATA = [DATA, dat(:)];
    
    if ~isempty( strfind(lower(fname), 'cat') )
        classes(ii) = 1;
    else
        classes(ii) = 0;
    end
end

if 0
    allNdx      = 1:size(DATA,2);
    trainNdx    = [1:77, 82:159];
    TrainData   = DATA(:,trainNdx);
    TrainClass  = classes( trainNdx );
    testNdx     = allNdx( ~ismember(allNdx,trainNdx) );
    TestSet    = DATA(:,testNdx);
    hiddenlabels   = classes( testNdx );
else
    TrainData = DATA;
    TrainClass = classes;
end

%{
allNdx      = 1:size(DATA,2);

trainNdx    = [1:77, 82:159];
TrainData   = DATA(:,trainNdx);
TrainClass  = classes( trainNdx );
testNdx     = allNdx( ~ismember(allNdx,trainNdx) );
TestData    = DATA(:,testNdx);
TestClass   = classes( testNdx );


X = TrainData; cats = (TrainClass == 0); dogs = (TrainClass == 1);

[yproj] = KLDA(DATA, TrainClass, X);
alpha = mean(yproj);

% X = TestData; cats = (TestClass == 0); dogs = (TestClass == 1);
% [yproj] = KLDA(TrainData, TrainClass, X);
%}

if PREPROCESS
    for ii = 1:size(TestSet,2)
        dat0 = TestSet(:,ii);
        dat = reshape(dat0, [64,64]);
        dat = imfilt(dat, 'average', [3,3]);
        dat = imfilt(dat, 'laplacian');
        dat = dat(:) - dat0(:);
        
        dat = dat - min(dat);
        dat = dat ./ max(dat);
        
        TestSet(:,ii) = dat(:);
    end
end

[yproj, yproj0] = KLDA(DATA, classes, TestSet);

alpha = mean(yproj0);

catst = (TrainClass==0); dogst = (TrainClass==1);
    
subplot(121);
ax1 = plot(yproj0(catst),0,'ob', 'MarkerSize',10); hold on;
ax2 = plot(yproj0(dogst),0,'+r', 'MarkerSize',10);
plot(alpha*[1,1], 0.1*[-1,1], ':k', 'LineWidth',2);

hold off; title 'Training Data'; legend([ax1(1),ax2(1)], 'Cats', 'Dogs');

% [yproj] = KLDA(DATA, classes, TestSet);

cats = (hiddenlabels==0); dogs = (hiddenlabels==1);
% cats = (classes==0); dogs = (classes==1);

subplot(122);
ax1 = plot(yproj(cats),0,'ob', 'MarkerSize',10); hold on;
ax2 = plot(yproj(dogs),0,'+r', 'MarkerSize',10);
plot(alpha*[1,1], 0.1*[-1,1], ':k', 'LineWidth',2);

hold off; title 'Test Data'; legend([ax1(1),ax2(1)], 'Cats', 'Dogs');

figure(gcf);

if all(yproj0(catst)>=alpha)
    cat_rate = sum(yproj(cats)>alpha) / sum(cats)
    dog_rate = sum(yproj(dogs)<=alpha) / sum(dogs)
    total_rate = 0.5*(cat_rate + dog_rate)
else
    cat_rate = sum(yproj(cats)<=alpha) / sum(cats)
    dog_rate = sum(yproj(dogs)>alpha) / sum(dogs)
    total_rate = 0.5*(cat_rate + dog_rate)
end

