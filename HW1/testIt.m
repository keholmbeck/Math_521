clear;

rng(10);

n = 1000;

theta = 2*pi * randn(n,1);

x{1} = [cos(theta), sin(theta)];


A1 = 0.01*randn(n);
x{2} = A1 * x{1};

A2 = 2*eye(n,n);
x{3} = A2 * x{1};

for ii = 1:length(x)
    plot(x{ii}(:,1), x{ii}(:,2), '.'); hold on;
end
hold off;

