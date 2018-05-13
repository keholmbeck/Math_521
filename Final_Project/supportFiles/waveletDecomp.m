function [filtered] = waveletDecomp(images, layers)

% Author: Debbie Tonne

[M,N] = size(images);

NBCODES = length(colormap(gray));

for i=1:N
    cA = reshape(images(:,i),[sqrt(M) sqrt(M)]);
    recon = [];
    
    for j = 1:layers
    [cA, cH, cV, cD] = dwt2(cA,'haar');
    H_details = wcodemat(cH,NBCODES);
    V_details = wcodemat(cV,NBCODES);
    D_details = wcodemat(cD,NBCODES);
    
    [m,n] = size(H_details);
    recon = [recon;reshape(H_details + V_details, [m*n 1])];
    end

    filtered(:,i) = recon;
end