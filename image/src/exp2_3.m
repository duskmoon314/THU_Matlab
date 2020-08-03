clear;
close all;
clc;

load('../assets/hall.mat');

width = 8;
imwrite(hall_gray, '../assets/2_3_origin.png');
img = double(hall_gray) - 128;

dct2 = @(block_struct) dct_2(block_struct.data);
dct2_lz = @(block_struct) dct_2_lz(block_struct.data);
dct2_rz = @(block_struct) dct_2_rz(block_struct.data);
idct2 = @(block_struct) idct2(block_struct.data);

C = blockproc(img, [width width], dct2, 'PadPartialBlocks', true);
C_lz = blockproc(img, [width width], dct2_lz, 'PadPartialBlocks', true);
C_rz = blockproc(img, [width width], dct2_rz, 'PadPartialBlocks', true);

img_inv = uint8(blockproc(C, [width width], idct2, 'PadPartialBlocks', true) + 128);
img_inv_lz = uint8(blockproc(C_lz, [width width], idct2, 'PadPartialBlocks', true) + 128);
img_inv_rz = uint8(blockproc(C_rz, [width width], idct2, 'PadPartialBlocks', true) + 128);

figure('Name', 'Exercise 2-3', 'NumberTitle', 'off');
subplot(3, 2, 1);
imshow(img_inv_lz);
imwrite(img_inv_lz, '../assets/2_3_inv_lz.png');
subplot(3, 2, 2);
imshow(img_inv_rz);
imwrite(img_inv_rz, '../assets/2_3_inv_rz.png');
subplot(3, 2, 3);
imshow(C_lz);
subplot(3, 2, 4);
imshow(C_rz);
subplot(3, 2, 5);
imshow(C);
subplot(3, 2, 6);
imshow(img_inv);
imwrite(img_inv, '../assets/2_3_inv.png');

figure;
subplot(3, 2, 1);
imshow(img_inv_lz(81:88, 57:64));
imwrite(imresize(img_inv_lz(81:88, 57:64), 20, 'nearest'), '../assets/2_3_inv_lz_p.png');
subplot(3, 2, 2);
imshow(img_inv_rz(81:88, 57:64));
imwrite(imresize(img_inv_rz(81:88, 57:64), 20, 'nearest'), '../assets/2_3_inv_rz_p.png');
subplot(3, 2, 3);
imshow(C_lz(81:88, 57:64));
subplot(3, 2, 4);
imshow(C_rz(81:88, 57:64));
subplot(3, 2, 5);
imshow(C(81:88, 57:64));
subplot(3, 2, 6);
imshow(img_inv(81:88, 57:64));
imwrite(imresize(img_inv(81:88, 57:64), 20, 'nearest'), '../assets/2_3_inv_p.png');

function C = dct_2_lz(P)
[w, h] = size(P);
assert(w==h, "P must be a square matrix");
P = double(P);
D = dct_mat(w);
C = D * P * D';
C(:, 1:4) = 0;
end

function C = dct_2_rz(P)
[w, h] = size(P);
assert(w==h, "P must be a square matrix");
P = double(P);
D = dct_mat(w);
C = D * P * D';
C(:, 5:8) = 0;
end