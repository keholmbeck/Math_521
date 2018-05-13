function [Xproj, Xproj0, alpha, w] = LDA(DATA, classes, TestData, opts)
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

if nargin == 3
    opts.doPCA = false;
    opts.tol = 0.95;
end

allClasses  = unique(classes);
nClasses    = length( allClasses );
ni          = zeros(nClasses,1);
for ii = 1:nClasses
    ni(ii) = sum(classes == allClasses(ii));
end

% approximate the data with lower dimensions (PCA)
% and transform into a new space (X)
if opts.doPCA
    [U,S,V] = svd(DATA,0);
    % [U,S,V] = svd(bsxfun(@minus, DATA, sum(DATA,2))/size(DATA,2), 0);
    E       = cumulative_energy(diag(S), rank(DATA));
    k       = find(E>opts.tol, 1);          % 99% rank approximation
    X       = S(1:k,1:k)*V(:,1:k)';     % use this new space
else
    X = DATA;
    k = size(DATA,1);
end

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

% A       = pinv(SW)*SB;
% [V,D]   = eig(A);
% D       = abs(diag(D));
% [D,ndx] = max(D);

[U1,V1,X1,C1,S1] = gsvd(SB, SW, 0);
[v,ndx] = max(diag(S1).*diag(C1));
w       = V1(:,ndx);

Xproj0  = w'*X;

if opts.doPCA
    TestData = U(:,1:k)'*TestData;
end

Xproj   = w'*TestData;

alpha = mean(Xproj0);

% alpha   = w'*m;         % alpha is only valid for nClasses=2

if nClasses == 2
    x1 = sort(Xproj0(classes == allClasses(1)));
    x2 = sort(Xproj0(classes == allClasses(2)));
    alpha = (max(x1) + min(x2))/2;
end

end
