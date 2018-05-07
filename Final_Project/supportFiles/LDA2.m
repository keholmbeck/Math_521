function [w,Xproj,alpha] = LDA(DATA, classes, tol)
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

if nargin == 2
    tol = 0.95;
end

allClasses  = unique(classes);
nClasses    = length( allClasses );
ni          = zeros(nClasses,1);
for ii = 1:nClasses
    ni(ii) = sum(classes == allClasses(ii));
end

if 1
    % approximate the data with lower dimensions (PCA)
    % and transform into a new space (X)
    DATA = bsxfun(@minus, DATA, sum(DATA,2))/size(DATA,2);
    [U,S,V] = svd(DATA, 0);
    [U, S, V] = mySVD(DATA');
    S = full(S);
    E       = cumulative_energy(diag(S), rank(DATA));
    k       = find(E>tol, 1);          % 99% rank approximation
    X = DATA;
    DATA    = U(:,1:k)';
    eigvecPCA = V(:,1:k) * pinv(S(1:k,1:k));
end

[k,nDat] = size(DATA);
m       = sum(DATA,2) / nDat;          % total mean

SB = zeros(k);
SW = zeros(k);
for ii = 1:nClasses
    thisClass   = ( classes==allClasses(ii) );
    classData   = DATA(:,thisClass);
    mu          = sum(classData,2) / ni(ii);   % current classwise mean
    SB          = SB + ni(ii)*(mu - m)*(mu - m)';
    
    for jj = 1:size(classData,2)
        SW = SW + (classData(:,jj) - mu)*(classData(:,jj) - mu)';
    end
end
% SB = SB*SB'; SW = SW*SW';

% %{
[V,D] = eig(SB,SW);
D       = abs(diag(D));
[D,ndx] = max(D);
w = V(:,ndx);
%}
%{
A       = pinv(SW)*SB;
[U,S,V] = svd(A);
[D,ndx] = max(diag(S));
w = U(:,ndx);
%}

% Xproj   = w'*DATA;
w       = eigvecPCA*w;
Xproj   = w'*X;
alpha   = 0;         % alpha is only valid for nClasses=2

if nClasses == 2
    x1 = sort(Xproj(classes == allClasses(1)));
    x2 = sort(Xproj(classes == allClasses(2)));
    alpha = (max(x1) + min(x2))/2;
end

end
