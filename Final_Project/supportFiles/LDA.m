function [w,Xproj,alpha] = LDA(DATA, classes)
% LDA
% Linear Discriminant Analysis
% 
% Syntax:
%   w = LDA(X, class)
% 
% where X is the entire data set and class indicates the class of each
% column of X. The function returns the projection vector, w, a vector
% whose length equals the number of columns of X, and the projected data, 
% Xproj.
% 

% Author: Kristin Holmbeck

allClasses  = unique(classes);
nClasses    = length( allClasses );
ni          = zeros(nClasses,1);
for ii = 1:nClasses
    ni(ii) = sum(classes == allClasses(ii));
end

% approximate the data with lower dimensions (PCA)
% and transform into a new space (X)
[U,S,V] = svd(DATA,0);
% [U,S,V] = svd(bsxfun(@minus, DATA, sum(DATA,2))/size(DATA,2), 0);
E       = cumulative_energy(diag(S), rank(DATA));
k       = find(E>0.99, 1);          % 99% rank approximation
X       = S(1:k,1:k)*V(:,1:k)';     % use this new space

nDat    = size(X,2);
m       = sum(X,2) / nDat;          % total mean

SB = zeros(k);
SW = zeros(k);
for ii = 1:nClasses
    thisClass   = ( classes==allClasses(ii) );
    classData   = X(:,thisClass);
    mu          = sum(classData,2) / ni(ii);   % current classwise mean
    SB          = SB + ni(ii)*(m-mu)*(m-mu)';
    
    for jj = 1:size(classData,2)
        SW = SW + (classData(:,jj) - mu)*(classData(:,jj) - mu)';
    end
end

A       = pinv(SW)*SB;
[V,D]   = eig(A);
D       = abs(diag(D));
[D,ndx] = max(D);
w       = V(:,ndx);
Xproj   = w'*X;
alpha   = w'*m;         % alpha is only valid for nClasses=2

end
