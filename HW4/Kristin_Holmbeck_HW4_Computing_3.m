clear;

rng(1028);
M = 250;
P = 10;
GEN_PLOT = false;

% Original denoised signal with mean removed
Signal = cumsum(randn(M,P));
Signal_EA = mean(Signal,2);
Signal = Signal-repmat(Signal_EA,1,P);

% Create Correlated Noise with Mean Removed
N0 = randn(M,3);
N1 = randn(3,P);
N = 1*N0*N1;
N_EA = mean(N,2);
N = N-repmat(N_EA,1,P);

% Observed Noisy Signal with mean Removed
X = Signal+N;
X_EA = mean(X,2);
X = X-repmat(X_EA,1,P);

if GEN_PLOT
    figure(1)
    for k = 1:P
        subplot(P,1,k)
        plot(Signal(:,k));title('Signal')
    end

    figure(2)
    for k = 1:P
        subplot(P,1,k);
        plot(N(:,k)); title('Noise In Columns of Noise Matrix')
    end
    figure(3);
    for k = 1:P
        subplot(P,1,k);
        plot(X(:,k)); title('Signals Observed In X')
    end
end

dX    = diff(X, 1);
[Phi, Basis] = MNF(X);

jj = 5;
plot(Signal(:,jj), '-k'); hold on;
plot(Basis(:,jj), ':ob'); hold on;
plot(X(:,jj), ':+r'); 
hold off;
legend 'True Signal' 'Approximated Signal' 'Known Signal'
title(sprintf('Sub-signal %d',jj), 'FontW', 'B');
saveas(gcf, 'data/MNF.png');

