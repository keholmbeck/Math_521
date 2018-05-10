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
    dat0 = double(dat);
    
    %{
    % preprocess the data
    dat = imfilt(dat, 'average', [3,3]);
    dat = imfilt(dat, 'laplacian');
    dat = dat - dat0;
%     subplot(121); imagesc(dat); axis image; subplot(122); imagesc(dat0-dat); axis image;
    %}
    dat = dat(:);
    
    DATA = [DATA, dat];
    
    if ~isempty( strfind(lower(fname), 'cat') )
        classes(ii) = 1;
    else
        classes(ii) = 0;
    end
end
DATA = double(DATA);

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
load PatternRecAns.mat

%{
% preprocess the data
for ii = 1:size(TestSet,2)
    dat0 = TestSet(:,ii);
    dat = reshape(dat0, [64,64]);
    dat = imfilt(dat, 'average', [3,3]);
    dat = imfilt(dat, 'laplacian');
    dat = dat(:) - dat0(:);
    TestSet(:,ii) = dat(:);
end
%}

[yproj, yproj0] = KLDA(DATA, classes, TestSet);
alpha = mean(yproj0);

cats = (classes==0); dogs = (classes==1);

subplot(121);
ax1 = plot(yproj0(cats),0,'ob', 'MarkerSize',10); hold on;
ax2 = plot(yproj0(dogs),0,'+r', 'MarkerSize',10);
plot(alpha*[1,1], 0.1*[-1,1], ':k', 'LineWidth',2);

hold off; title 'Test Data'; legend([ax1(1),ax2(1)], 'Cats', 'Dogs');

% [yproj] = KLDA(DATA, classes, TestSet);

cats = (hiddenlabels==0); dogs = (hiddenlabels==1);
% cats = (classes==0); dogs = (classes==1);

subplot(122);
ax1 = plot(yproj(cats),0,'ob', 'MarkerSize',10); hold on;
ax2 = plot(yproj(dogs),0,'+r', 'MarkerSize',10);
plot(alpha*[1,1], 0.1*[-1,1], ':k', 'LineWidth',2);

hold off; title 'Training Data'; legend([ax1(1),ax2(1)], 'Cats', 'Dogs');

figure(gcf);

cat_rate = sum(yproj(cats)<=alpha) / sum(cats)
dog_rate = sum(yproj(dogs)>alpha) / sum(dogs)
total_rate = 0.5*(cat_rate + dog_rate)


