function [U,S,V] = best_basis(X)

avg = ensemble_average(X);
P   = size(X,2);
Xm  = bsxfun(@minus, X, avg);
[U,S,V] = svd(Xm, 0);

end
