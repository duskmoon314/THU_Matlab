clear;
close all;
clc;

jpegcode = load('jpegcodes.mat');
load('../assets/JpegCoeff.mat');
load('zigzag.mat');
load('../assets/hall.mat');

img = JPEG_decode(jpegcode.DC, jpegcode.AC, jpegcode.height, jpegcode.width, QTAB, ACTAB, zigzag_inv_ind);
PSNR = 10 * log10(255^2 * jpegcode.height * jpegcode.width / norm(double(img - hall_gray), 'fro')^2);
disp(PSNR);
figure('Name', 'Exercise 2-11', 'NumberTitle', 'off');
subplot(1,2,1);
imshow(img);
title(PSNR);
imwrite(img, '../assets/2_11_decode.png');
subplot(1,2,2);
imshow(hall_gray);
imwrite(hall_gray, '../assets/2_11_origin.png');