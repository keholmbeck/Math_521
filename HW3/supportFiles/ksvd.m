function [U,S,V] = ksvd(X)
% KSVD
% Calculate the SVD of a matrix X
% 
% Syntax
% 
% 

r = rank(X);
[m,n] = size(X);

if m < n
    XX = X'*X;
else
    XX = X*X';
end

E = sort(eig(XX), 'descend');
S = zeros(r,r);
for ii = 1:length(E)
    S(ii,ii) = E(ii);
end

U = zeros(m,r);
V = zeros(r,r);

I = eye(m);
for ii = 1:r
    V(:,ii) = null(X'*X - sqrt(E(ii))*I);
end

end
