function theta = prinAngles(X1,X2)

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

% Compute the principal angles for k = 1,...,q
theta = zeros(size(X2,2), 1);
Sind  = (S.^2) < 0.5;
Mind  = (M.^2) <= 0.5;

theta(Sind) = acos(S(Sind));
theta(Mind) = asin(M(Mind));

% principal angles are listed in ascending order:
theta = sort(theta);

end
