function [w,Xproj] = fda(DATA, classes)
% FDA
% Fisher Discriminant Analysis
% 
% Syntax:
%   w = FDA(X, class)
% 
% where X is the entire data set and class indicates the class of each
% column of X. The function returns the projection vector, w, a vector
% whose length equals the number of columns of X, and the projected data, 
% Xproj.
% 

% Author: Kristin Holmbeck

ni = [sum(classes==1), sum(classes==2)];

% approximate the data with lower dimensions:
[U,S,V] = svd(DATA,0);
X = S*V';

X1 = X(:,(classes==1));
X2 = X(:,(classes==2));

m1 = sum(X1,2) / ni(1);
m2 = sum(X2,2) / ni(2);
m  = (m1+m2)/2;

SW = zeros(sum(ni));
for ii = 1:size(X,2)
    if classes(ii) == 1
        mu = m1;
    else
        mu = m2;
    end
    SW = SW + (X(:,ii) - mu)*(X(:,ii) - mu)';
end

SW1 = bsxfun(@minus, X1, m1);
SW2 = bsxfun(@minus, X2, m2);
SWt = SW1*SW1' + SW2*SW2';
% SW = SWt;

SB = (m2-m1)*(m2-m1)';

wt = pinv(SW)*(m1-m2);

A       = pinv(SW)*SB;
[U,S,V] = svd(A,0);
w       = U(:,1);
Xproj   = w'*X;

alpha = w'*m;

end

