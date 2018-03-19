function X = ensemble_average(X)
% ENSEMBLE_AVERAGE
% 
% Syntax:
%   Y = ensemble_average(X)
% 
% Given a data set of vectorized images, each column representing a single
% image, this function computes the ensemble average, defined by the sum of
% the column vectors divided by the number of columns.
% 

nx = size(X,2);
X  = sum(X,2) / nx;

end
