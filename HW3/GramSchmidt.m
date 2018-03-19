clear;

A = [1 -1; 2 0 ; 0 1];
x = [0; 2; 1];

% 
% Perform the Gram-Schmidt algorithm
% 

% take the first normalized col vector to be the first orth. basis vector
u1 = A(:,1);
u1 = u1 ./ norm(A(:,1));

B = zeros(size(A));
B(:,1) = u1;

% Define the projection function
proj = @(u,v) (u'*v) / (u'*u) * u;

for ii = 2:size(A,2)
    tmp = 0;
    % sum the projections
    for jj = 2:ii
        tmp = tmp + proj(B(:,jj-1), A(:,ii));
    end
    % tmp = (current vector) - (sum of projections)
    tmp = A(:,ii) - tmp;
    
    % normalize, and set as new orth. basis vector
    B(:,ii) = tmp / norm(tmp);
end
