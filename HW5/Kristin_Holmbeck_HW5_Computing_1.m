clear;

im_orig = imread('data/app-ndt-Chip-5.jpg');
im_orig = rgb2gray(im_orig);
im_orig = double( im_orig );

% create the salt-and-pepper image
noise   = rand(size(im_orig));
im      = im_orig;
im(noise > 0.9) = 255;
im(noise < 0.1) = 0;

filtSiz = [3,3];

im_med = imfilt(im, 'median', filtSiz);

clf;
imagesc(im_orig); axis off; colormap gray;
title 'Original Image' FontW B
saveas(gcf, 'data/im_orig.png');

imagesc(im); axis off; colormap gray;
title 'Noisy Image' FontW B
saveas(gcf, 'data/im_noise.png');

imagesc(im_med); axis off; colormap gray;
title 'Median-Filtered Image' FontW B
saveas(gcf, 'data/im_filt.png');

tmp = abs(im_orig - im_med);
imagesc(-double(tmp>10)); axis off; colormap gray
title 'Binary Pixel Difference' FontW B;
saveas(gcf, 'data/im_diff_bin.png');
return;

% compare with MATLAB's builtin median filter
B = medfilt2(im, filtSiz);
tmp = B - im_med;