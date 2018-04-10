clear;

foldername = 'data/EEG_for_FDA/';
files = dir(foldername);
files = files(3:end);

task = 2:3;
trials = 0:9;
ntrials = length(trials);
CLASS_2 = [];
CLASS_3 = [];

for c = task
    for trial = trials
        dat = load([foldername, sprintf('class-%d_seq-%d', c, trial)])';
        
        if c == 2
            CLASS_2 = [CLASS_2, dat];
        else
            CLASS_3 = [CLASS_3, dat];
        end
    end
end

% CLASS_2 = CLASS_2'; CLASS_3 = CLASS_3';

m1 = sum(CLASS_2,2) / size(CLASS_2,2);
m2 = sum(CLASS_3,2) / size(CLASS_3,2);

% SB = m2-m1;
X1 = CLASS_2;
X2 = CLASS_3;
A  = m2-m1;
B  = sum(bsxfun(@minus, X1, m1) + bsxfun(@minus, X2, m2), 2);

[U,V,X,C,S] = gsvd(A,B,0);
