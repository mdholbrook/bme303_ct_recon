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

figure(21)
imshow(mat2gray(y'))
axis off, axis image
title('Sinogram')
set(gcf, 'position', [400 200 700 700])
pause()

%% Simple back projection

x1 = iradon(y, theta, 'none');
mx = max(x1(:));
    figure(31)

for z = 1:length(theta)

    x = iradon(y(:,1:z), theta(1:z), 'none');


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
title('Reconstruction')
pause()

subplot(1, 3, 3)
plot(im(center, :), 'linewidth', 2), hold on
plot(x(center, :)/mx, 'r', 'linewidth', 2), hold off
axis tight
legend('Object', 'Reconstruction')
xlabel('Pixels')
ylabel('Intensity')
title('Line profiles')