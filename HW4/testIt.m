clear;

N = 3;
M = 64;     % size of spatial grid
P = 64;     % number of points in the ensemble

xm = (1:M)* 2*pi / M;
tm = (1:P)* 2*pi / P;

[T,X] = meshgrid(tm, xm);

f   = zeros(M,P);
mmu = ones(M,P);        % known mask for gappy data
k   = ceil(0.10*M);     % 0.10 of indices will be gappy

for ii = 1:N
    f = f + sin(ii*(X-T))/ii;
end
for ii = 1:P
    ndx = randperm(M, k);
    mmu(ndx,ii) = 0;
end

f = f / N;      % true data
x = f.*mmu;     % gappy data

% -------------------------------------
% Type 1 algorithm: we have a good basis --
% 
%   

xrecon = x;

% Type 2 algorithm: we don't have a good basis --
% 
%   make an initial repair with the ensemble average
%   compute first estimate of KL basis
%   do until convergence:
%       re-estimate the gappy data using Type 1 algorithm
%       recompute the KL basis
% 
xtilde = ensemble_average(x);
