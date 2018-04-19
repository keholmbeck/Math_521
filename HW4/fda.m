function [w,Xproj,alpha] = FDA(DATA, classes)
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
% [U,S,V] = svd(DATA,0);
[U,S,V] = best_basis(DATA);
E = cumulative_energy(diag(S), rank(DATA));
k = find(E>0.95, 1);    % use 90% rank approximation
X_new = U(:,1:k)'*DATA;
X = S(1:k,1:k)*V(:,1:k)';


X1 = X(:,(classes==1));
X2 = X(:,(classes==2));

m1 = sum(X1,2) / ni(1);
m2 = sum(X2,2) / ni(2);
m  = (m1+m2)/2;

SW = zeros(k);
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
% SB =  ni(1)*(m-m1)*(m-m1)' +  ni(2)*(m-m2)*(m-m2)';

A       = pinv(SW)*SB;
[V,D]   = eig(A);
D       = abs(diag(D));
[D,ndx] = max(D);
w       = V(:,ndx);

% [U,S,V] = svd(A,0);
% w       = U(:,1);
Xproj   = w'*X_new;
alpha   = w'*m;

end

