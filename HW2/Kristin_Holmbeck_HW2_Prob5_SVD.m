clear;

A = [-2 -1 1
    0 -1 0
    -1 1 2
    1 -1 1];

[Um,Sm,Vm] = svd(A);

ATA = A'*A;

S = sort(eig(ATA), 'descend');
I = eye(3);

V = [null(ATA - S(1)*I), null(ATA-S(2)*I), null(ATA-S(3)*I)];

S = sqrt( [diag(S); zeros(1,3)] );

U = A*V*pinv(S);
U(:,end) = null(A*A');

% generate rank-k approximations to A
for k = 1:size(A,2)
    Ak{k} = U(:,1:k)*S(1:k,1:k)*V(:,1:k)';
end

% sprintf for LaTeX generation
for k = 1:size(Ak,2)
    str = sprintf('A_%d &= \\begin{bmatrix} ', k);
    tmp = Ak{k};
    for ii = 1:size(tmp,1)
        for jj = 1:size(tmp,2)
            str = [str, sprintf('%g', tmp(ii,jj)) ];
            if jj < size(tmp,2)
                str = [str, ' && '];
            end
        end
        if ii < size(tmp,1)
            str = [str, sprintf('\\\\ \n')];
        end
    end
    str = [str, sprintf('\\end{bmatrix} \\\\ ')];
    disp(str);
end

A_rank_norms = cellfun(@(x) norm(A-x), Ak);


