clear;

im = imread('data/CTimage.jpg');
im = rgb2gray(im);
im = double( im );

filtSiz = [3,3];
im_avg = imfilt(im, 'average', filtSiz);
im_edge = imfilt(im_avg, 'laplacian');
im_edge2 = (im_edge - min(im_edge(:))) / (max(im_edge(:)) - min(im_edge(:)));
im_sharp = im - im_edge;

images = {im, im_avg, im_edge, im_sharp};
names  = {'CTimage', 'CTavg', 'CTlap', 'CTsharp'};

for ii = 1:length(images)
    imagesc( images{ii} );
    axis image; axis off; colormap gray;
    saveas(gcf, ['data/', names{ii}, '.png']);
end

imagesc(im - im_sharp); colormap gray; axis off; colorbar;
saveas(gcf, 'data/CTdiff.png');

imagesc(im - im_sharp - im_edge); colormap gray; axis off; colorbar;
saveas(gcf, 'data/CTdiff_edge.png');
