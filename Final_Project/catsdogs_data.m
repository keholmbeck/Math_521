clear;

load data/cats_and_dogs.mat
load PatternRecAns.mat

GEN_FLIP_IM = 0;
PREPROCESS = 1;

if PREPROCESS || GEN_FLIP_IM
    nDat = size(DATA,2);
    for ii = 1:nDat
        dat = DATA(:,ii);
        dat = reshape(dat, [64,64]);
        tmp = dat;
        
        if PREPROCESS
            tmp = imfilt(dat, 'average', [3,3]);
            tmp = imfilt(tmp, 'laplacian');
%             tmp = tmp - dat;
            tmp = wcodemat(tmp, 64);
            
            DATA(:,ii) = tmp(:);
        end
        
        if GEN_FLIP_IM
            tmp = fliplr(tmp);
            DATA = [DATA, tmp(:)];
        end
    end
    if GEN_FLIP_IM
        classes = [classes, classes];
    end
end

if PREPROCESS
    % preprocess the data
    for ii = 1:size(TestSet,2)
        dat0 = TestSet(:,ii);
        dat0 = reshape(dat0, [64,64]);
        dat = imfilt(dat0, 'average', [3,3]);
        dat = imfilt(dat, 'laplacian');
%         dat = dat - dat0;
        dat = wcodemat(dat, 64);
        
        TestSet(:,ii) = dat(:);
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

[yproj, yproj0] = KLDA(TrainData, TrainClass, TestSet);
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


