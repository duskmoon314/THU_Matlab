clear;
close all;
clc;

load('../assets/hall.mat');
load('../assets/JpegCoeff.mat');
load('zigzag.mat');

img = double(hall_gray);
max_length = numel(img);
% secret = randi([0, 1], 1, randi(max_length));
secret = randi([0, 1], 1, max_length);
correct = 0;

[img_decode_1, ratio_1, PSNR_1, secret_decode_1, code_1] = ...
    dct_embed_1(img, QTAB, DCTAB, ACTAB, zigzag_ind, zigzag_inv_ind, secret);
[img_decode_2, ratio_2, PSNR_2, secret_decode_2, code_2] = ...
    dct_embed_2(img, QTAB, DCTAB, ACTAB, zigzag_ind, zigzag_inv_ind, secret(1 : floor(max_length / 8)), 2, 8);
[img_decode_3, ratio_3, PSNR_3, secret_decode_3, code_3] = ...
    dct_embed_3(img, QTAB, DCTAB, ACTAB, zigzag_ind, zigzag_inv_ind, secret(1 : floor(max_length / 64)));

disp(['ratio 1: ', num2str(ratio_1)]);
disp(['PSNR 1: ', num2str(PSNR_1)]);
disp(['correct 1: ', num2str(sum(secret_decode_1 == secret) / length(secret))]);

disp(['ratio 2: ', num2str(ratio_2)]);
disp(['PSNR 2: ', num2str(PSNR_2)]);
disp(['correct 2: ', num2str(sum(secret_decode_2 == secret(1 : floor(max_length / 8))) / length(secret(1 : floor(max_length / 8))))]);

disp(['ratio 3: ', num2str(ratio_3)]);
disp(['PSNR 3: ', num2str(PSNR_3)]);
disp(['correct 3: ', num2str(sum(secret_decode_3 == secret(1 : floor(max_length / 64))) / length(secret(1 : floor(max_length / 64))))]);

figure('Name', 'Exercise 3-2', 'NumberTitle', 'off');
subplot(2,2,1);
imshow(uint8(img));
subplot(2,2,2);
imshow(uint8(img_decode_1));
title('embed 1');
imwrite(img_decode_1, '../assets/3_2_embed_1.png');
subplot(2,2,3);
imshow(uint8(img_decode_2));
title('embed 2');
imwrite(img_decode_2, '../assets/3_2_embed_2.png');
subplot(2,2,4);
imshow(uint8(img_decode_3));
title('embed 3');
imwrite(img_decode_3, '../assets/3_2_embed_3.png');