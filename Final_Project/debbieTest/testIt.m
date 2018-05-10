clear; close all;
folder = 'TIFFtraining/';
files = dir( folder );		% get all the files in this folder
files = files(3:end);		% throw out the first two: '.' and '..'

DATA = [];

% this is a vector that denotes which columns are in which class
classes = zeros(1, length(files));

for ii = 1:length(files)
    fname = files(ii).name;		% get current filename
    dat = imread([folder, fname]);	% read the image from the file
    dat = dat(:,:,1);    		% this takes care of the "bad" case
    dat = dat(:);	  		% vectorize
    
    DATA = [DATA, dat];			% append to the big data matrix
    
    % if the filename contains "cat", write "1" to the class vector
    % otherwise, write "0" to the class vector
    if ~isempty( strfind(lower(fname), 'cat') )
        classes(ii) = 1;
    else
        classes(ii) = 0;
    end
end
DATA = double(DATA);

class_Cat = DATA(:,classes==1);
class_Dog = DATA(:,classes==0);

for i = 1:160
train = [class_Cat, class_Dog];

probe = train(:,i);
if i >80
    true_label = 0;
    train_Cat = train(:,1:80);
    train_Dog = [train(:,81:i-1),train(:,i+1:160)];
else
    true_label = 1;
    train_Cat = [train(:,1:i-1),train(:,i+1:80)];
    train_Dog = train(:,81:160);
end

% filter images
train_Cat = laplacianFilter(train_Cat);
train_Dog = laplacianFilter(train_Dog);
probe_filt = laplacianFilter(probe);

% add data
train_Cat = addData(train_Cat);
train_Dog = addData(train_Dog);

energy = .95;

classify(i) = LDA_classification(train_Cat,train_Dog,probe_filt,energy);

check = 1-abs(true_label - classify(i));
error(i) = sum(abs(check));
end

percent = sum(error)/160