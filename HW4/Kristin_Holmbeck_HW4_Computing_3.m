clear;

rng(1028);

GEN_PLOTS = false;

N = 3;
M = 300;    % size of spatial grid
P = 250;     % number of points in the ensemble

xm = ((1:M)-1)* 2*pi / M;
tm = ((1:P)-1)* 2*pi / P;

[T,X] = meshgrid(tm, xm);

f    = zeros(M,P);
mask = ones(M,P);        % known mask for gappy data
k    = ceil(0.10*M);     % 0.10 of indices will be gappy

for ii = 1:N
    f = f + sin(ii*(X-T))/ii;
end
xt = f / N;
noise = 0.1*randn(M,P);
X = xt + noise;

[U,S,V] = best_basis(X);     % KL-basis
E       = cumulative_energy(diag(S), rank(X));
D       = find(E>0.90, 1);    % use 90% rank approximation
Xrep    = U(:,1:D)*S(1:D,1:D)*V(:,1:D)';

%{
truth = randn(n,m);
noise = truth.^2;
X = truth + noise;
%}

dX = diff(X, 1);

NTN = 0.5 * dX'*dX;

[V,D] = eig(pinv(X'*X)*(noise'*noise));
[~,ndx] = max(diag(D));
w = V(:,ndx);

% Take the eigenvector expansion of the covariance of dX
[U1,S1,V1] = svd(noise'*noise);

S1_inv = sqrt(S1)^-1;

% Whiten the original data
wX = X*U1*S1_inv;

% Compute the eigenvector expansion of the covariance of wX
[U2,S2,V2] = svd(wX'*wX);

% Define Phi
Phi = U1*S1_inv*V2;

% Compute the Maximum noise fraction basis vectors
Basis = X*Phi;

