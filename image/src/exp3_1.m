clear;
close all;
clc;

load('../assets/hall.mat');
load('../assets/JpegCoeff.mat');
load('zigzag.mat');

img = double(hall_gray);
max_length = numel(img);

correct = 0;

% commet parfor to use imshow(encode)

parfor i = 1:100
    secret = randi([0, 1], 1, randi(max_length));
    len = length(secret);
    secret_pad = [secret, zeros(1, max_length - len)];
    
    encode = reshape(bitshift(bitshift(img, -1), 1), 1, []);
    encode = reshape(encode + secret_pad, size(img));
    [DC, AC, height, width] = JPEG_encode(encode, QTAB, DCTAB, ACTAB, zigzag_ind);
    decode = JPEG_decode(DC, AC, height, width, QTAB, ACTAB, zigzag_inv_ind);

    secret_decode = reshape(decode, 1, []);
    secret_decode = mod(secret_decode(1:len), 2);

    correct = correct + sum(secret_decode == secret) / len;
end

% disp(correct / 100);


figure('Name', 'Exercise 3-1', 'NumberTitle', 'off');
% subplot(1,2,1);
imshow(uint8(img));
% subplot(1,2,2);
% imshow(uint8(encode));