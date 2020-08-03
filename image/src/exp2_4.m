clear;
close all;
clc;

load('../assets/hall.mat');

width = 8;
imwrite(hall_gray, '../assets/2_3_origin.png');
img = double(hall_gray) - 128;

dct2 = @(block_struct) dct_2(block_struct.data);
dct2_t = @(block_struct) dct_2_t(block_struct.data);
dct2_rot90 = @(block_struct) dct_2_rot90(block_struct.data);
dct2_rot180 = @(block_struct) dct_2_rot180(block_struct.data);
idct2 = @(block_struct) idct2(block_struct.data);

C = blockproc(img, [width width], dct2, 'PadPartialBlocks', true);
C_t =  blockproc(img, [width width], dct2_t, 'PadPartialBlocks', true);
C_rot90 = blockproc(img, [width width], dct2_rot90, 'PadPartialBlocks', true);
C_rot180 =  blockproc(img, [width width], dct2_rot180, 'PadPartialBlocks', true);

img_inv = uint8(blockproc(C, [width width], idct2, 'PadPartialBlocks', true) + 128);
img_inv_t = uint8(blockproc(C', [width width], idct2, 'PadPartialBlocks', true) + 128);
img_inv_Ct = uint8(blockproc(C_t, [width width], idct2, 'PadPartialBlocks', true) + 128);
img_inv_rot90 = uint8(blockproc(rot90(C), [width width], idct2, 'PadPartialBlocks', true) + 128);
img_inv_Crot90 = uint8(blockproc(C_rot90, [width width], idct2, 'PadPartialBlocks', true) + 128);
img_inv_rot180 = uint8(blockproc(rot90(C, 2), [width width], idct2, 'PadPartialBlocks', true) + 128);
img_inv_Crot180 = uint8(blockproc(C_rot180, [width width], idct2, 'PadPartialBlocks', true) + 128);

figure('Name', 'Exercise 2-4', 'NumberTitle', 'off');
subplot(2, 3, 1);
imshow(img_inv_rot90);
imwrite(img_inv_rot90, '../assets/2_4_inv_rot90.png');
subplot(2, 3, 2);
imshow(img_inv_rot180);
imwrite(img_inv_rot180, '../assets/2_4_inv_rot180.png');
subplot(2, 3, 3);
imshow(img_inv_t);
imwrite(img_inv_t, '../assets/2_4_inv_t.png');
subplot(2, 3, 4);
imshow(img_inv_Crot90);
imwrite(img_inv_Crot90, '../assets/2_4_inv_Crot90.png');
subplot(2, 3, 5);
imshow(img_inv_Crot180);
imwrite(img_inv_Crot180, '../assets/2_4_inv_Crot180.png');
subplot(2, 3, 6);
imshow(img_inv_Ct);
imwrite(img_inv_Ct, '../assets/2_4_inv_Ct.png');

function C = dct_2_t(P)
[w, h] = size(P);
assert(w==h, "P must be a square matrix");
P = double(P);
D = dct_mat(w);
C = D * P * D';
C = C';
end

function C = dct_2_rot90(P)
[w, h] = size(P);
assert(w==h, "P must be a square matrix");
P = double(P);
D = dct_mat(w);
C = D * P * D';
C = rot90(C);
end

function C = dct_2_rot180(P)
[w, h] = size(P);
assert(w==h, "P must be a square matrix");
P = double(P);
D = dct_mat(w);
C = D * P * D';
C = rot90(C, 2);
end