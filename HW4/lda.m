function [w,Xproj] = lda(DATA, classes)
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

allClasses = unique(classes);
nClasses = length( allClasses );
ni = zeros(nClasses,1);
for ii = 1:nClasses
    ni(ii) = sum(classes == allClasses(ii));
end

% approximate the data with lower dimensions:
[U,S,V] = svd(DATA,0);
X       = S*V';

nDat    = size(X,2);
m       = sum(X,2) / nDat;

SB = zeros(nDat);
SW = zeros(nDat);
for ii = 1:nClasses
    classData   = X(:,( classes==allClasses(ii) ));
    mu          = sum(classData,2) / ni(ii);   % current classwise mean
    SB          = SB + ni(ii)*(m-mu)*(m-mu)';
    
    for jj = 1:size(classData,2)
        SW = SW + (classData(:,jj) - mu)*(classData(:,jj) - mu)';
    end
end
%{
SW1 = SW;
SB1 = SB;

SW = zeros(nDat);

X1 = X(:,(classes==1));
X2 = X(:,(classes==2));

m1 = sum(X1,2) / ni(1);
m2 = sum(X2,2) / ni(2);
m  = (m1+m2)/2;

for ii = 1:size(X,2)
    
    if classes(ii) == 1
        mu = m1;
    else
        mu = m2;
    end
    SW = SW + (X(:,ii) - mu)*(X(:,ii) - mu)';
end

SB = ni(1)*(m1 - m)*(m1-m)' + ni(2)*(m2-m)*(m2-m)';
%}

A       = pinv(SW)*SB;
[U,S,V] = svd(A,0);
w       = U(:,1);
Xproj   = w'*X;

alpha = (w'*m1 +  w'*m2)/2;

end

