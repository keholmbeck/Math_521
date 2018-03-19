function X = map2uint8(X)
% Map a set of data to [0,255], with each data set being ordered by the
% column.

% shift min values to zero
% scale to [0,1]
% scale to [0,255]

X = X - min(X(:));
X = X ./ max(X(:));

% X = X ./ max(X);
% X = bsxfun(@minus, X, min(X));
% X = bsxfun(@rdivide, X, max(X));
X = ceil(X * 255);

end