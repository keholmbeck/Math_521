function new_data = addData(data)

[M,N] = size(data);
new_data = zeros(M,2*N);
new_data(:,1:N) = data;

for i=1:N
    A = reshape(data(:,i),[sqrt(M) sqrt(M)]);
    % Flip Image
    A = fliplr(A);
    
%     % Rotate Image
%     A = rotate(A, rand*pi/4, [floor(M/2) floor(M/2) 1]');
    
%     % Shift Image
%     A = translate(A, )
    
    new_data(:,i+N) = reshape(A, [M 1]);
end