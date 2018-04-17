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

DATA = [CLASS_2, CLASS_3];
DATA_M = bsxfun(@minus, DATA, sum(DATA,2));
classes = [ones(1,10), 2*ones(1,10)];

[w, yproj, alpha] = lda(DATA, classes);
[w1, yproj1, alpha1] = lda(DATA_M, classes);

return

% h1 = gscatter(CLASS_2',CLASS_3',classes','krb','ov^',[],'off');
% h1(1).LineWidth = 2;
% h1(2).LineWidth = 2;
% legend(spec{1}, spec{2},'Location','best')
% 
% return


% DATA = load('Digits.mat');
% DATA = double(DATA.Gallery);
% classes = repmat(0:9, 50, 1);
% classes = classes(:);
% [w, yproj] = lda(DATA, classes);

%{
ncols = length(classes);
ndx = randperm(ncols);
DATA = DATA(:,ndx);
classes = classes(ndx);
%}
% DATA = bsxfun(@minus, DATA, sum(DATA,2));   % mean-subtracted data

c1=[1,2; 2,3; 3,3; 4,5; 5,5];
c2=[1,0; 2,1; 3,1; 3,2; 5,3; 6,5];
m1 = mean(c1)';
m2 = mean(c2)';
S1 = 4*cov(c1);
S2 = 5*cov(c2);
SW = S1 + S2;
v = pinv(SW)*(m1-m2);
v2 = [-0.65; 0.73];

y1 = v'*c1';
y2 = v'*c2';


X1 = [4,2; 2,4; 2,3; 3,6; 4,4];
X2 = [9,10; 6,8; 9,5; 8,7; 10,8];
classes = [1, 1, 2, 2];
DATA = [X1, X2];


m1 = mean(X1)';
m2 = mean(X2)';
SW = cov(X1) + cov(X2);
SB = (m2-m1)*(m2-m1)';
[U,S,V] = svd(pinv(SW)*SB);

w = -U(:,1);

[w1, yproj] = fda(DATA, classes);

y1 = w'*X1';
y2 = w'*X2';

slope = w(2)/w(1);
line = @(x) slope *x;
x = -1:15;
plot(x, line(x), 'k'); hold on;
plot(X1(:,1), X1(:,2), 'ob'); plot(X2(:,1), X2(:,2),'or');hold off;

return

load fisheriris;
PL = meas(:,3);
PW = meas(:,4);

spec = unique(species);
spec1 = cellfun(@(x) isequal(x, spec{1}), species);
spec2 = cellfun(@(x) isequal(x, spec{2}), species);
spec3 = cellfun(@(x) isequal(x, spec{3}), species);

MdlLinear = fitcdiscr([PL,PW],species);

h1 = gscatter(PL,PW,species,'krb','ov^',[],'off');
h1(1).LineWidth = 2;
h1(2).LineWidth = 2;
h1(3).LineWidth = 2;
legend('Setosa','Versicolor','Virginica','Location','best')
hold on
K = MdlLinear.Coeffs(2,3).Const;
L = MdlLinear.Coeffs(2,3).Linear;
f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
h2 = ezplot(f,[.9 7.1 0 2.5]);
h2.Color = 'r';
h2.LineWidth = 2;
hold off;

% return

X = [PL(spec1|spec2), PW(spec1|spec2)];
class = species(spec1|spec2);
MdlLinear = fitcdiscr(X,class);

h1 = gscatter(X(:,1),X(:,2),class,'krb','ov^',[],'off');
h1(1).LineWidth = 2;
h1(2).LineWidth = 2;
legend(spec{1}, spec{2},'Location','best')
hold on
K = MdlLinear.Coeffs(2,1).Const;
L = MdlLinear.Coeffs(2,1).Linear;
f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
h2 = ezplot(f,[.9 7.1 0 2.5]);
h2.Color = 'r';
h2.LineWidth = 2;
hold off;

% [w, yproj] = fda(X, [1,2]);
