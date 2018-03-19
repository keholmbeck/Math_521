clear;

X = [-2  -1  1
      0  -1  0
     -1   1  2
      1  -1  1];

[U1,S1,V1] = svd(X*X', 0);
[U2,S2,V2] = svd(X'*X, 0);
[U,S,V] = svd(X, 0);

for ii = 1:rank(X)
    DV  = diag(V(:,ii));
    tmp = sum(X*DV, 2);
    tmp = tmp / S(ii,ii);
    
    max(abs(tmp - U(:,ii)))
end
