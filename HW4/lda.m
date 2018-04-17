function [w,Xproj,alpha] = lda(DATA, classes)
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

% approximate the data with lower dimensions:
[U,S,V] = svd(DATA,0);
[U,S,V] = best_basis(DATA);
X       = S*V';

nDat    = size(X,2);
m       = sum(X,2) / nDat;

SB = zeros(nDat);
SW = zeros(nDat);
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
alpha   = w'*m;

end

