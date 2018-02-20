clear;

%{
I = double(imread('data/coins.png'));

alpha = [2;2];
theta = pi/4;
horiz = -100;
vert = 200;

P = [150;50;1];
ims = scale(I, alpha, P);
imr = rotate(I, theta, P);
imh = translateH(I, horiz);
imv = translateV(I, vert);

ax = [1,1,1];

ax = imagesc(I); title 'Original';
saveas(ax, 'data/orig.png');

ax = imagesc(ims); 
title(sprintf('Scaled by %0.1f in x, %0.1f in y', alpha));
saveas(ax, 'data/scaled.png');

ax = imagesc(imh); 
title(sprintf('Translated horizontally by %0d', horiz));
saveas(ax, 'data/horiz.png');

ax = imagesc(imv); 
title(sprintf('Translated vertically by %0d', vert));
saveas(ax, 'data/vert.png');

ax = imagesc(imr); 
title(sprintf('Rotated by %d degrees', theta*180/pi));
saveas(ax, 'data/rotated.png');

subplot(131); imagesc(I); title 'Original';
subplot(132); imagesc(ims); 
title(sprintf('Scaled by %0.1f in x, %0.1f in y', alpha));
subplot(133); imagesc(imr); 
title(sprintf('Rotated by %d degrees', theta*180/pi));

return;

newImg1 = translateH(I, 50);
newImg2 = translateH(I, -50);


subplot(131); imagesc(I); title 'Original'
subplot(132); imagesc(newImg1); title 'Positive Vert Shift'
subplot(133); imagesc(newImg2); title 'Negative Vert Shift';
return
%}

%{
rng(10);

n = 1000;

theta = 2*pi * randn(1,n);

x{1} = [cos(theta); sin(theta)];
A1 = 1*randn(2);
x{2} = A1 * x{1};

A2 = 2*eye(2);
x{3} = A2 * x{1};

[A3,~] = qr(A1);
x{4} = A3 * x{1};

x{5} = A3 * x{2};

k = ceil(n/2);
ax = zeros(length(x), 1);
c = {'k','b','r','m','g'};
for ii = 1:length(x)
    ax(ii) = plot(x{ii}(1,:), x{ii}(2,:), '.'); hold on;
    plot(x{ii}(1,k), x{ii}(2,k), ['o',c{ii}]); hold on;
end
legend(ax, 'Original Data', 'A1', 'A2', 'A3', 'Location', 'SE');
hold off;
saveas(gcf, 'data/rand_unit_circ_pts.png');
%}

load data/face1;
load data/face2;

[theta,truth] = prinAngles(face1, face2);
% theta = 180/(2*pi)*theta;

F1 = reshape(face1, 160,138, 21);
F2 = reshape(face2, 160,138, 21);

return

for ii = 1:size(face1,2)
    subplot(131);
    imagesc(reshape(face1(:,ii),160,138)), colormap(gray), axis off
    
    subplot(132);
    imagesc(reshape(face2(:,ii),160,138)), colormap(gray), axis off
    title(sprintf('Iteration %d', ii), 'FontW', 'B');
    
    subplot(133);
    plot(theta); hold on; plot(ii, theta(ii), 'or'); hold off;
    ylabel 'degrees';
    
    drawnow;
    pause(0.5);
end

hold off;
