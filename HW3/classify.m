function NDX = classify(X, D, siz)
% CLASSIFY
% 
% Classify the images from the columns of D as columns of the training set
% X.
% 
% Syntax:
%   ndx = CLASSIFY(training_set, test_set);
% 
% If [m,n] = size(test_set), the ndx vector is nx1, returning the index of
% each column of D classified by the column of X.
% 

% Author; Kristin Holmbeck

M = ensemble_average([X,D]);
X = M(:,1:size(X,2));
D = M(:,size(X,2)+1:end);

% X = ensemble_average(X);
% D = ensemble_average(D);

[Ux,Sx,Vx] = svd(X,0);

%  project D onto eigenspace
Pr = Ux;
% Pr = Ux(:,1:100);
Pr = Pr * Pr';
Dproj = Pr*D;

NDX = zeros(size(D,2), 1);

for ii = 1:size(Dproj,2)
    tmp     = abs( bsxfun(@minus, X, Dproj(:,ii)) );
    tmp     = sum(tmp,1)';
    [v,ndx] = min(tmp);
    NDX(ii) = ndx;
    
    if nargin == 3
        subplot(121); imagesc(reshape(X(:,ndx),siz)); colorbar
        subplot(122); imagesc(reshape(Dproj(:,ii),siz)); colorbar
        pause
    end
end

end
