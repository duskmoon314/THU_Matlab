clear;
close all;
clc;

load('zigzag.mat');
load('../assets/JpegCoeff.mat');
load('../assets/hall.mat');

[DC, AC, height, width] = JPEG_encode(hall_gray, QTAB, DCTAB, ACTAB, zigzag_ind);

save('jpegcodes.mat', 'DC', 'AC', 'height', 'width');