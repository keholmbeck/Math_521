function h = disp_pattern(A)

Z = zeros(2*size(A,1)+1, 2*size(A,2)+1);
n = 0;
for ii = 2:2:size(Z,2)
    n = n + 1;
    Z(2:2:end,ii) = A(:,n);
end

h = imagesc(Z);

end
