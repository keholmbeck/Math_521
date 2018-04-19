function [xhat, eigData] = repair_gappy_data(xhat, mask, maxit)
% REPAIR_GAPPY_DATA
% 
% Syntax:
%   [X_repair, eigData] = REPAIR_GAPPY_DATA(X, mask)
% 
% where X is the given data and mask is the matrix indicating where the
% gaps are to be filled in (by value=0 at gap, value=1 elsewhere).
% 
% The outputs are the repaired data, X_repair, and the iteration data
% containing the eigenvalues and eigenvectors in a cell:
%       eigData = {U_0, sigma_0;
%                  U_1, sigma_1;
%                   ...
%                  U_iter, sigma_iter};
% 
% Algorithm: assuming we don't have a good basis --
% 
%   1) make an initial repair with the ensemble average
%   2) compute first estimate of KL basis
%   3) do until convergence:
%         a) re-estimate the gappy data using Type 1 algorithm
%         b) recompute the KL basis
% 

% Author: Kristin Holmbeck

if nargin == 2
    maxit = 50;     % maximum number of iterations
end

cvg_tol     = 1e-6;
P           = size(xhat,2);
Pi          = sum(mask,2);
xavg        = sum(xhat,2) ./ Pi;
xavg        = repmat(xavg, 1, P);
xhat(~mask) = xavg(~mask);          % fill in initial gaps with ensemble avg

eigData = {};
D       = P;

for iter = 1:maxit
    [U,S,V] = best_basis(xhat);     % KL-basis
    
    if iter == 1
        E = cumulative_energy(diag(S), rank(xhat));
        D = find(E>0.90, 1);    % use 90% rank approximation
    end
    
    % need to do a D-approximation of xhat
    U = U(:,1:D);
    S = S(1:D,1:D);
    
    eigData{iter,1} = U;
    eigData{iter,2} = diag(S);
    eigData{iter,3} = xhat;
    
    if iter > 1
        sigdiff = eigData{iter,2} - eigData{iter-1,2};
        if max(abs(sigdiff)) < cvg_tol
            return
        end
    end
    
    b = zeros(D,P);
    
    for mm = 1:P
        
        mu      = mask(:,mm);
        Umask   = U .* repmat(mu, 1, D);
        Ms      = Umask' * Umask;
        f       = Umask' * (xhat(:,mm).*mu);
        
    %{
        % The long way of doing it --
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
            f(jj) = (xhat(:,mm).*mu)' * Umask(:,jj);
        end
    %}
        
        b(:,mm) = pinv(Ms)*f;
    end
    
    repair      = U*b;
    xhat(~mask) = repair(~mask);
end

end
