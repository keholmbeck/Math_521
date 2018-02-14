function [theta,truth] = prinAngles(X1,X2)

% Find orthonormal bases for X1,X2
Q1 = orth(X1);
Q2 = orth(X2);

% Compute SVD for cosine
S = svd(Q1' * Q2);

% Compute matrix Y
if rank(Q1) >= rank(Q2)
    Y = Q2 - Q1*(Q1'*Q2);
else
    Y = Q1 - Q2*(Q2'*Q1);
end

% SVD for sine
M = svd(Y);
M = M(end:-1:1);


% Compute the principal angles for k = 1,...,q
theta = zeros(size(X2,2), 1);
Sind  = (S.^2) < 0.5;
Mind  = (M.^2) <= 0.5;

theta(Sind) = acos(S(Sind));
theta(Mind) = asin(M(Mind));

% % principal angles are listed in ascending order:
% theta = sort(theta);

truth = [1.0081    1.1159    1.2027    1.2276    1.2915    1.3709    1.3860    1.4227    1.4294    1.4682    1.4865    1.5117    1.5185    1.5286    1.5433    1.5480    1.5480    1.5573    1.5573    1.5690 1.5690]';

end
