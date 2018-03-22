clear;

X = [-2  -1  1
      0  -1  0
     -1   1  2
      1  -1  1];

[U1,S1,V1] = svd(X*X', 0);
[U2,S2,V2] = svd(X'*X, 0);
[Ut,St,Vt] = svd(X, 0);

ATA = X'*X;
AAT = X*X';

% do the SVD "by hand"

E1 = sort(eig(ATA), 'descend');
E2 = sort(eig(AAT), 'descend');

I3 = eye(3);
I4 = eye(4);

for ii = 1:4
    V_AAT{ii} = null(AAT - E2(ii)*I4);
end
V_AAT = [V_AAT{:}];

for ii = 1:3
    V_ATA{ii} = null(ATA - E1(ii)*I3);
end
V_ATA = [V_ATA{:}];

% Confirming the statement for u^{(1)}:

k = 1;
u1 = 0;
for ii = 1:size(X,2)
    u1 = u1 + X(:,ii)*Vt(ii,k);
end
% u1 = u1 / sqrt(S1(1));

return

disp_for_latex( V_AAT );
disp_for_latex( V_ATA );
