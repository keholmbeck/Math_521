function [Phi, Basis] = MNF(X,N)
% this algorithm requires the knowledge of N (noise)
% treat N as noise and X as data in the gsvd.

if nargin == 2
    [U,V,A,C,S] = gsvd(N,X,0);
    psi = pinv(A');
    Phi = X*psi; % optimal basis vectors
    Basis = psi;
else
    [Phi,Basis] = MaximumNoiseFraction(X);
end

end

function [Phi,Basis] = MaximumNoiseFraction(X)
% https://www.mathworks.com/matlabcentral/fileexchange/49884-maximumnoisefraction
% 
% Function to  compute the Maximum Noise Fraction from a set of signals X(:,i)
% based on paper A SOLUTION PROCEDURE FOR BLIND SIGNAL SEPARATION 
% USING THE MAXIMUM NOISE FRACTION APPROACH: ALGORITHMS AND EXAMPLES
% 
% Input   X: data set X with rows > column, here each colum is a signal
% Output  BasisVectors: output signals 
%         Phi: Transformation matrix
        

[m, n] = size(X);

% 1. Estimate the covariance of the noise.
dX = zeros(m,n);
for i=1:(m-1)
    dX(i,:) = X(i,:) - X(i+1,:);
end

% Take the eigenvector expansion of the covariance of dX
[U1,S1,V1] = svd(dX'*dX);

% Whiten the original data
wX = X*U1*inv(sqrt(S1));

% Compute the eigenvector expansion of the covariance of wX
[U2,S2,V2] = svd(wX'*wX);

% Define Phi
Phi = U1*inv(sqrt(S1))*U2;

% Compute the Maximum noise fraction basis vectors
Basis = X*Phi;

end
