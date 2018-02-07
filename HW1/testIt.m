clear;

%{
I = imread('coins.png');

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
%}

load face1;
load face2;

theta = prinAngles(face1, face2);
theta = 180/(2*pi)*theta;

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
