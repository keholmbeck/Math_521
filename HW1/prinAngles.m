function theta = prinAngles(X1,X2)

% Find orthonormal bases for X1,X2
[Q1,R1] = qr(X1,0);
[Q2,R2] = qr(X2,0);
% Q1 = orth(X1);
% Q2 = orth(X2);

% Compute SVD for cosine
[U,S,V] = svd(Q1' * Q2);
S = diag(S);

% Compute matrix Y
if rank(Q1) >= rank(Q2)
    Y = Q2 - Q1*(Q1'*Q2);
else
    Y = Q1 - Q2*(Q2'*Q1);
end

% SVD for sine
[U,M,V] = svd(Y,0);
M = diag(M);

% Compute the principal angles for k = 1,...,q
theta = zeros(size(X2,2), 1);
for ii = 1:length(theta)
    if S(ii)^2 < 1/2
        theta(ii) = acos(S(ii));
    end
    if M(ii)^2 <= 1/2
        theta(ii) = acos(M(ii));
    end
end

end
