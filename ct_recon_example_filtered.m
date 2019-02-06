%% CT_recon_example.m

clear; clc; close all;
get(0,'defaultfigureposition')
%% Make image
im_size = 256;
rad = 15;
center = 100;

im = zeros(im_size);

[xx, yy] = meshgrid(1:im_size, 1:im_size);

im(sqrt((xx - center).^2 + (yy - center).^2) < rad) = 1;

figure(11)
imshow(im)
axis off, axis image
title('Object')
set(gcf, 'position', [400 200 700 700])
pause()


%% Take radon transform

n_projs = 90;
theta = linspace(0, 360, n_projs);
y = radon(im, theta);

%% Filtered back projection


x1 = iradon(y, theta, 'linear');
mx = max(x1(:));
    figure(31)

for z = 1:length(theta)

    x = iradon(y(:,1:z), theta(1:z), 'linear');


    imshow(x/mx)
    axis off, axis image
    title('Simple back projecction')
    
    if z < 5
        pause()
    else
        pause(0.2)
    end
end

pause()

%% Line profiles

figure(41)
set(gcf, 'position', [300 200 1400 600])
subplot(1, 3, 1)
imshow(im)
line([1, im_size], [center, center], 'linewidth', 2)
axis off, axis image
title('Object')
pause() 

subplot(1, 3, 2)
imshow(x/mx)
line([1, im_size], [center, center], 'color', 'r', 'linewidth', 2)
axis off, axis image
title('Reconstruction (ramp filter)')
pause() 

subplot(1, 3, 3)
plot(im(center, :), 'linewidth', 2), hold on
plot(x(center, :)/mx, 'r', 'linewidth', 2), hold off
axis tight
legend('Object', 'Reconstruction')
xlabel('Pixels')
ylabel('Intensity')
title('Line profiles')
pause()


figure(42)
x2 = iradon(y, theta, 'hann');
set(gcf, 'position', [300 200 1400 600])
subplot(1, 3, 1)
imshow(im)
line([1, im_size], [center, center], 'linewidth', 2)
axis off, axis image
title('Object')
pause() 

subplot(1, 3, 2)
imshow(x2/max(x2(:)))
line([1, im_size], [center, center], 'color', 'r', 'linewidth', 2)
axis off, axis image
title('Reconstruction (hann filter)')
pause() 

subplot(1, 3, 3)
plot(im(center, :), 'linewidth', 2), hold on
plot(x2(center, :)/max(x2(:)), 'r', 'linewidth', 2), hold off
axis tight
legend('Object', 'Reconstruction')
xlabel('Pixels')
ylabel('Intensity')
title('Line profiles')
pause()

%% Death star


dstar = rgb2gray(imread('deathstar.jpg'));

ystar = radon(dstar, theta);

xstar1 = iradon(ystar, theta, 'none');
xstar2 = iradon(ystar, theta, 'linear');
xstar3 = iradon(ystar, theta, 'hann');


figure(51)
subplot(1, 4, 1)
imshow(mat2gray(dstar))
axis image, axis off
title('Object')

subplot(1, 4, 2)
imshow(mat2gray(xstar1))
axis image, axis off
title('No filter')

subplot(1, 4, 3)
imshow(mat2gray(xstar2))
axis image, axis off
title('Ramp filter')

subplot(1, 4, 4)
imshow(mat2gray(xstar3))
axis image, axis off
title('Hann filter')