function im_out = imfilt(im, filtType, filtSiz)
% IMFILT
% Image filtering.
% 
% Syntax:
%   im_out = IMFILT(im_in, filtType)
%   im_out = IMFILT(im_in, filtType, filtSiz)
% 
% where filterSiz is a 2-element vector specifying the size of the median
% filter, and filtType is a string that can have the following values:
%   'median'
%   'average'
%   'laplacian' (uses the 3x3 matrix with -4 at the center)
% 

% Author: Kristin Holmbeck, April 2018

if nargin == 2
    filtSiz = [3,3];
end

filtType = lower(filtType);
switch filtType
    case 'median'
        ffun = @median;
    case 'average'
%         ffun = @mean;
        AvgFilt = ones(filtSiz) / prod(filtSiz);
        ffun = @(x) sum(AvgFilt(:).*x);
    case 'laplacian'
        LapFilt = [0,  1, 0;
                   1, -4, 1;
                   0,  1, 0];
        filtSiz = size(LapFilt);
        ffun = @(x) sum(LapFilt(:).*x);
    otherwise
        error('Filter type not defined for this method');
end

% Created a padded image
im_siz      = size(im);
im_pad      = zeros(im_siz + 2*filtSiz);
im_new      = im_pad;
sub_rows    = (filtSiz(1)-1)+[1:im_siz(1)];
sub_cols    = (filtSiz(2)-1)+[1:im_siz(2)];
im_pad(sub_rows, sub_cols) = im;

fs = floor(filtSiz/2);      % not sure if this line is correct in general
for ii = sub_rows
    for jj = sub_cols
        % get neighbors of current pixel
        % apply the filter to that neighborhood
        dat = im_pad(ii-fs(1):ii+fs(1), jj-fs(2):jj+fs(2));
        im_new(ii,jj) = ffun( dat(:) );
    end
end

im_out = im_new(sub_rows, sub_cols);

end
