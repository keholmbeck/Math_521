function [U,S,V] = best_basis(X)

Xm = ensemble_average(X);

[U,S,V] = svd(Xm, 0);

end
