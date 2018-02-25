function Ak = rank_k_approx(U,S,V,k)

Ak = U(:,1:k) * S(1:k,1:k) * V(:,1:k)';

end

