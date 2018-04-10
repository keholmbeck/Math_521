function [U,S,V] = best_basis(X)

% Xm = ensemble_average(X);

nx = size(X,2);
Xa = sum(X,2) / nx;
Xm  = bsxfun(@minus, X, Xa);

[U,S,V] = svd(Xm, 0);

end
