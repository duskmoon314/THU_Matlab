clear;
close all;
clc;

load('../assets/JpegCoeff.mat');
load('zigzag.mat');
load('../assets/hall.mat');

[DC, AC, height, width] = JPEG_encode(hall_gray, QTAB / 2, DCTAB, ACTAB, zigzag_ind);
img_Q2 = JPEG_decode(DC, AC, height, width, QTAB / 2, ACTAB, zigzag_inv_ind);
PSNR = 10 * log10(255^2 * height * width / norm(double(img_Q2 - hall_gray), 'fro')^2);
disp(PSNR);
figure('Name', 'Exercise 2-12', 'NumberTitle', 'off');
subplot(1,2,1);
imshow(img_Q2);
title(PSNR);
imwrite(img_Q2, '../assets/2_12_decode.png');
subplot(1,2,2);
imshow(hall_gray);