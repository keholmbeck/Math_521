function [U,S,V] = best_basis(X)

nx = size(X,2);
Xa = sum(X,2) / nx;
Xm  = bsxfun(@minus, X, Xa);    % mean-subtracted data
% Xm = ensemble_average(X);

[U,S,V] = svd(Xm, 0);

end
