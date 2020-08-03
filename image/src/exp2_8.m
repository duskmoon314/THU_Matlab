clear;
close all;
clc;

load('zigzag.mat');
load('../assets/JpegCoeff.mat');
load('../assets/hall.mat');

img = double(hall_gray) - 128;

process = @(block_struct) dct_process(block_struct.data, QTAB, zigzag_ind);

DCT = blockproc(img, [8 8], process, 'PadPartialBlocks', true);
DCT = reshape(DCT', size(DCT, 2), 64, []);
DCT = permute(DCT, [2, 1, 3]);
DCT = reshape(DCT, 64, []);

function output = dct_process(input, QTAB, zigzag_ind)
    C = dct_2(input);
    C_quant = round(C ./ QTAB);
    C_zigzag = C_quant(zigzag_ind);
    output = C_zigzag';
end