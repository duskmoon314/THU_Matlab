clear;
close all;
clc;

load('../assets/JpegCoeff.mat');
load('zigzag.mat');
load('../assets/snow.mat');

[DC, AC, height, width] = JPEG_encode(snow, QTAB, DCTAB, ACTAB, zigzag_ind);
snow_decode = JPEG_decode(DC, AC, height, width, QTAB, ACTAB, zigzag_inv_ind);

disp(norm(double(snow_decode - snow), 'fro')^2 / (height * width));
PSNR = 10 * log10(255^2 * height * width / norm(double(snow_decode - snow), 'fro')^2);
disp(PSNR);
figure('Name', 'Exercise 2-13', 'NumberTitle', 'off');
subplot(1,2,1);
imshow(snow_decode);
title(PSNR);
imwrite(snow_decode, '../assets/2_13_decode.png');
subplot(1,2,2);
imshow(snow);
imwrite(snow, '../assets/2_13_snow.png');