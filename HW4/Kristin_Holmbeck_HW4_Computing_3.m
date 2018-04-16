clear;

n = 250;
m = 10;

truth = randn(n,m);
noise = truth.^2;

X = truth + noise;
dX = diff(X, 1);

N = 0.5 * dX'*dX;


% Take the eigenvector expansion of the covariance of dX
[U1,S1,V1] = svd(dX'*dX);

S1_inv = sqrt(S1)^-1;

% Whiten the original data
wX = X*U1*S1_inv;

% Compute the eigenvector expansion of the covariance of wX
[U2,S2,V2] = svd(wX'*wX);

% Define Phi
Phi = U1*S1_inv*V2;

% Compute the Maximum noise fraction basis vectors
Basis = X*Phi;
