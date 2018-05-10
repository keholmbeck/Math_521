function k = findRank(S,var)

sigma = diag(S);
sigmaTot = sum(sigma.^2);

Ek = 0; k =0;
while Ek < var && k < nnz(S)
    k = k +1;
    Ek = Ek + sigma(k)^2/sigmaTot;
end
end