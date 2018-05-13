function filtered = laplacianFilter(images)

% Author: Debbie Tonne

[M,N] = size(images);
filtered = zeros(M,N);

% average filter
avg_filt = (1/16)*[1 2 1; 2 4 2; 1 2 1];

% Laplacian filter
lap_filt = [-1 -1 -1; -1 8 -1; -1 -1 -1];

for i=1:N
    A = reshape(images(:,i),[sqrt(M) sqrt(M)]);
    A = conv2(A,avg_filt,'same');
    A = conv2(A,lap_filt,'same');
    A = wcodemat(A,sqrt(M));
    filtered(:,i) = reshape(A,[M 1]);
end
