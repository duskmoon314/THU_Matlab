clear;
close all;
clc;

load('../assets/hall.mat');

width = 8;
[h, w] = size(hall_gray);
D = dctmtx(width);

piece_x = floor(rand * (h - width) + 1);
piece_y = floor(rand * (w - width) + 1);
test_piece = double(hall_gray(piece_x:(piece_x + width - 1), ...
                              piece_y:(piece_y + width - 1)));
% spatial domain
piece_sd = test_piece - 128;
dct_sd = D * piece_sd * D';

% frequency domain
dct_fd = D * test_piece * D';
dct_fd(1,1) = dct_fd(1,1) - 128 * width;

disp(norm(dct_sd - dct_fd));

figure('Name', 'Exercise 2-1', 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(dct_sd);
subplot(1, 2, 2);
imshow(dct_fd);