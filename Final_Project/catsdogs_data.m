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
allNdx      = 1:size(DATA,2);

trainNdx    = [1:77, 82:159];
TrainData   = DATA(:,trainNdx);
TrainClass  = classes( trainNdx );
testNdx     = allNdx( ~ismember(allNdx,trainNdx) );
TestData    = DATA(:,testNdx);
TestClass   = classes( testNdx );

% %{
X = TrainData; cats = (TrainClass == 0); dogs = (TrainClass == 1);

[yproj] = KLDA(TrainData, TrainClass, X);
alpha = mean(yproj);

% X = TestData; cats = (TestClass == 0); dogs = (TestClass == 1);
% [yproj] = KLDA(TrainData, TrainClass, X);

ax1 = plot(yproj(cats),0,'ob', 'MarkerSize',10); hold on;
ax2 = plot(yproj(dogs),0,'+r', 'MarkerSize',10);
plot(alpha*[1,1], 0.1*[-1,1], ':k', 'LineWidth',2);

% yproj = w'*TestData; 
% ax3 = plot(yproj(TestClass==0),0.02,'db', 'MarkerSize',10);
% ax4 = plot(yproj(TestClass==1),0.02,'dr', 'MarkerSize',10);

hold off; title LDA; legend([ax1(1),ax2(1)], 'Dogs', 'Cats');
figure(gcf);
return;


% [w, yproj, alpha] = LDA(TrainData, TrainClass, TestData);
%}
testNdx     = allNdx( ~ismember(allNdx,trainNdx) );
TestData    = DATA(:,testNdx);
TestClass   = classes( testNdx );


[w, eigvalue] = LDA_CAD(TrainData',TrainClass');
yproj = w'*TrainData;

% subplot(121);
ax1 = plot(yproj(TrainClass==0),0,'ob', 'MarkerSize',10); hold on;
ax2 = plot(yproj(TrainClass==1),0,'+r', 'MarkerSize',10);

yproj = w'*bsxfun(@minus, TestData, mean(TrainData,2));
% ax3 = plot(yproj(otherDat),0,'dg', 'MarkerSize',10);
ax3 = plot(yproj(TestClass==0),0.02,'db', 'MarkerSize',10);
ax4 = plot(yproj(TestClass==1),0.02,'dr', 'MarkerSize',10);

% plot(alpha*[1,1], 0.1*[-1,1], ':k', 'LineWidth',2);

hold off; title LDA; legend([ax1(1),ax2(1)], 'Dogs', 'Cats');
figure(gcf);

