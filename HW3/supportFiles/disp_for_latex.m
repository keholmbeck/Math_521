function disp_for_latex(M)

fprintf('\n\n');
fprintf('\\begin{bmatrix}')

for ii = 1:size(M,1)
    for jj = 1:size(M,2)
        fprintf('%0.2f ', M(ii,jj))
        if jj < size(M,2)
            fprintf('&& ');
        end
    end
    if ii < size(M,1)
        fprintf('\\\\ ')
    end
end

fprintf('\\end{bmatrix}')
fprintf('\n\n');

end
