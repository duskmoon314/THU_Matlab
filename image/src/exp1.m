clear;
close all;
clc;

load("../assets/hall.mat")
img = im2double(hall_color);

[h, w, c] = size(img);
[x, y] = meshgrid(1:w, 1:h);

pos = [[w, h] / 2, min([w, h] / 2)];
img_circle = insertShape(img, 'Circle', pos, ...
                         'color', 'red', 'Opacity', 1);

% circle_mask = ((x - pos(1)).^2 + (y - pos(2)).^2 >= pos(3).^2 + 60) ...
%                | ((x - pos(1)).^2 + (y - pos(2)).^2 <= pos(3).^2 - 60);
% img_circle = img .* circle_mask;
% img_circle(:,:,1) = img_circle(:,:,1) + ~circle_mask;

% phi = 0:1:359;
% x_ = max(min(round(pos(1) + pos(3) * cos(phi)), w), 1);
% y_ = max(min(round(pos(2) + pos(3) * sin(phi)), h), 1);
% img_circle = img;
% img_circle(sub2ind(size(img), y_, x_, ones(1, 360))) = 1;
% img_circle(sub2ind(size(img), y_, x_, 2 * ones(1, 360))) = 0;
% img_circle(sub2ind(size(img), y_, x_, 3 * ones(1, 360))) = 0;

grid_width = 10;
x_mask = mod(floor(x / grid_width), 2);
y_mask = mod(floor(y / grid_width), 2);
grid_mask = double(xor(x_mask, y_mask));
img_grid = grid_mask .* img;

figure('Name', 'Exercise 1', 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(img_circle);
subplot(1, 2, 2);
imshow(img_grid);

imwrite(img_circle, '../assets/1_circle.png');
imwrite(img_grid, '../assets/1_grid.png');
