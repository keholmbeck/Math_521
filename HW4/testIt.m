clear;

rng(1028);

N = 3;
M = 64;     % size of spatial grid
P = 64;     % number of points in the ensemble

xm = ((1:M)-1)* 2*pi / M;
tm = ((1:P)-1)* 2*pi / P;

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
mmu = logical(mmu);

xt = f / N;      % true data
xg = xt.*mmu;     % gappy data

% -------------------------------------
% Type 1 algorithm: we have a good basis --
% 
%   


% Type 2 algorithm: we don't have a good basis --
% 
%   make an initial repair with the ensemble average
%   compute first estimate of KL basis
%   do until convergence:
%       re-estimate the gappy data using Type 1 algorithm
%       recompute the KL basis
% 

Pi = sum(mmu,2);

xhat = xg;

xavg        = sum(xhat,2) ./ Pi;
xavg        = repmat(xavg, 1, P);
xhat(~mmu)  = xavg(~mmu);   % fill in initial gaps with ensemble avg

x1 = xhat;

for kk = 1:3
%     xavg        = sum(xhat,2) ./ Pi;
%     xavg        = repmat(xavg, 1, P);
%     xhat(~mmu)  = xavg(~mmu);   % fill in initial gaps with ensemble avg
    
    [U,S,V]     = best_basis(xhat);
    
    D = 6;      % need to do a D-approximation of xhat
    U = U(:,1:D);
    S = S(1:D,1:D);
    V = V(:,1:D);
    
    b = zeros(D,P);
    
    for mm = 1:P
        mu = mmu(:,mm);
        
        Ms = zeros(D,D);
        for ii = 1:size(Ms,1)
            for jj=1:size(Ms,2)
                Ui = U(:,ii);
                Uj = U(:,jj);
                Ms(ii,jj) = (Ui.*mu)' * (Uj.*mu);
            end
        end
        f = zeros(D,1);
        for jj = 1:D
            f(jj) = (xhat(:,mm).*mu)' * (U(:,jj).*mu);
        end
        b(:,mm) = pinv(Ms)*f;
    end
    
    xnew        = U*b;
    r           = U*b;
    xhat(~mmu)  = r(~mmu); continue;
    
    xavg        = sum(xnew,2) ./ Pi;
    xavg        = repmat(xavg, 1, P);   % ensemble average of xnew
    xhat(~mmu)  = xavg(~mmu);
end
