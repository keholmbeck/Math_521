function [yproj, yproj0, alpha] = KLDA(DATA, classes, TestData, options)
% KLDA
% Kernel Linear Discriminant Analysis
% 
% Syntax:
%   yproj = KLDA(TrainData, TrainClassLabel, TestData)
%   yproj = KLDA(TrainData, TrainClassLabel, TestData, options)
% 
% where TrainData is the entire data set and TrainClassLabel indicates the 
% class of each column of TrainData.
% 
% The function returns the vector yproj, which is the projection of
% TestData onto the space.
% 
% The options input is a structure that controls whether or not we perform
% PCA.
% 

% Author: Kristin Holmbeck

if nargin == 3
    options.doPCA = 1;
    options.tol = 0.999;
end

allClasses  = unique(classes);
nClasses    = length( allClasses );
ni          = zeros(nClasses,1);
for ii = 1:nClasses
    ni(ii) = sum(classes == allClasses(ii));
end

% meanDat = sum(DATA,2) / size(DATA,2);
% DATA = bsxfun(@minus, DATA, meanDat);
% TestData = bsxfun(@minus, TestData, meanDat);

if options.doPCA
    % approximate the data with lower dimensions (PCA)
    % and transform into a new space (X)
    X       = DATA;
    [U,S,V] = svd(DATA,0);
    % [U,S,V] = svd(bsxfun(@minus, DATA, sum(DATA,2))/size(DATA,2), 0);
    E       = cumulative_energy(diag(S), rank(DATA));
    k       = find(E>options.tol, 1);
    DATA    = S(1:k,1:k)*V(:,1:k)';     % use this new space
end

npts = size(DATA,2);

M = zeros(npts, 2);
N = zeros(npts, npts);
for ii = 1:nClasses
    thisClass   = ( classes==allClasses(ii) );
    classData   = DATA(:,thisClass);
    
    Ki = zeros(npts, ni(ii));
    for jj = 1:npts
        for kk = 1:ni(ii)
            Ki(jj,kk) = kernel(DATA(:,jj), classData(:,kk));
        end
    end
    I = eye(ni(ii));
    L = ones(ni(ii)) * (1/ni(ii));
    N = N + Ki*(I - L)*Ki';
    
    for jj = 1:ni(ii)
        for kk = 1:npts;
            M(:,ii) = M(:,ii) + kernel(DATA(:,kk), classData(:,jj));
        end
    end
    M(:,ii) = M(:,ii) / ni(ii);    

%     M(:,ii) = sum(Ki,2) / ni(ii);    
end
% N = N + 1e-3*eye(npts);  % regularization term

% ASSUME WE ONLY HAVE 2 CLASSES
M1 = M(:,1);
M2 = M(:,2);
M  = (M1-M2)*(M1-M2)';

% [V,D]   = eig(M,N);
% D       = abs(diag(D));
% [D,ndx] = max(D);
% alpha   = V(:,ndx);

[U1,V1,X1,C1,S1] = gsvd(M,N,0);
[v,ndx] = max(diag(C1).*diag(S1));
alpha = V1(:,ndx);

% project testing data
if options.doPCA
    TestData = U(:,1:k)'*TestData;
end

% project training data
yproj0 = zeros(size(DATA,2), 1);
for jj = 1:size(DATA,2)
%     for ii = 1:size(DATA,2)
%         yproj0(jj) = yproj0(jj) + alpha(ii)*kernel(DATA(:,ii), DATA(:,jj));
%     end
    yproj0(jj) = kernel(DATA, DATA(:,jj)) * alpha;
end


yproj = zeros(size(TestData,2), 1);
for jj = 1:size(TestData,2)
%     for ii = 1:size(DATA,2)
%         yproj(jj) = yproj(jj) + alpha(ii)*kernel(DATA(:,ii), TestData(:,jj));
%     end
    yproj(jj) = kernel(DATA, TestData(:,jj)) * alpha;
end

end

function k = kernel(x,y)

switch 1
    case 0
        k = y'*x;
    case 1
        % k = exp(-norm(x-y).^2 / 0.5);
        tmp = bsxfun(@minus, x, y);
        k = exp( -(tmp(1,:).^2 + tmp(2,:).^2) / 0.5 );
    otherwise
        error('Invalid kernel type');
end

end

