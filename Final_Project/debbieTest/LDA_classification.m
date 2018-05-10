function classify = LDA_classification(class1,class2,probe,energy)

np = size(probe,2);
n1 = size(class1,2);
n2 = size(class2,2);

% reduce dimensions
train = [class1, class2];
meanT = mean(train,2);
train = train - repmat(meanT, [1 n1+n2]);
[U,S,V] = svd(train,0);

k = findRank(S,energy);
U = U(:,1:k); S = S(1:k,1:k); V = V(:,1:k);
class_new = S*V';
C1 = class_new(:, 1:n1);
C2 = class_new(:,n1+1:n1+n2);

class1 = U'*class1;
class2 = U'*class2;
probe = U'*probe;

% Scatter between classes
m1 = mean(C1,2);
m2 = mean(C2,2);
S_B = (m2 - m1)*(m2 - m1)';

% Scatter w/in classes
S_w1 = (C1 - m1)*(C1 - m1)';
S_w2 = (C2 - m2)*(C2 - m2)';

S_W = S_w1 + S_w2;

% Find projection vector
L = pinv(S_B)*S_W;
[V,D] = eig(S_B,S_W);
[~,ind] = max(abs(diag(D)));
w = V(:,ind);

% Project Class1 and Class 2 onto real line
c1_proj = w'*class1;
c2_proj = w'*class2;

% Find threshold

% forced class1 to be on the left and c1 to be on the right
if mean(c2_proj)>mean(c1_proj)
    w = -w;
    c1_proj = -c1_proj;
    c2_proj = -c2_proj;
end

sort1 = sort(c1_proj);
ind1 = 1;
sort2 = sort(c2_proj);
ind2 = size(c2_proj,2);

while sort2(ind2) > sort1(ind1)
    ind1 = ind1 + 1;
    ind2 = ind2 - 1;
end

alpha = (sort1(ind1) + sort2(ind2))/2;

% alpha = (w(:,1)'*m1 + w(:,1)'*m2)/2; %midpoint

% alpha = (max(c1_proj) + min(c2_proj))/2; % This does not work generally

% Classify probe data
probe_proj = w'*probe;

classify = zeros(1,np);
classify(probe_proj>alpha) = 1;