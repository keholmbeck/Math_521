function E = cumulative_energy(sigmas, r)
% sigmas is the vector of singular values, in descending order
% r is the rank of the image

if nargin == 1
    r = length(sigmas);
end

sigmas = sigmas(1:r);
sigmas = sigmas.^2;

E = cumsum(sigmas);
E = E ./ E(end);

end

