clear;
close all;
clc;

load('../assets/hall.mat');

width = 8;
img = double(hall_gray) - 128;

mat_dct2 = @(block_struct) dct2(block_struct.data);
my_dct2 = @(block_struct) dct_2(block_struct.data);

mat_c = blockproc(img, [width width], mat_dct2, 'PadPartialBlocks', true);
my_c = blockproc(img, [width width], my_dct2, 'PadPartialBlocks', true);

disp(norm(mat_c - my_c));

figure('Name', 'Exercise 2-2', 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(mat_c);
subplot(1, 2, 2);
imshow(my_c);