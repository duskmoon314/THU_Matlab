function [DC, AC, height, width] = JPEG_encode(img, QTAB, DCTAB, ACTAB, zigzag)
% JPEF_ENCODE Encode JPEG
% param img: pictuer matrix
% param QTAB: quantization matrix
% param DCTAB: DC code table
% param ACTAB: AC code table
% param zigzag: Zig-Zag index
% return DC: DC encoded
% return AC: AC encoded
% return height: img height
% return width: img width

img = double(img) - 128;
[height, width] = size(img);

process = @(block_struct) block_process(block_struct.data, QTAB, zigzag);
coef = blockproc(img, [8 8], process, 'PadPartialBlocks', true);
coef = reshape(coef', size(coef, 2), 64, []);
coef = permute(coef, [2, 1, 3]);
coef = reshape(coef, 64, []);
blocks = size(coef, 2);

DC_coef = coef(1, :);
AC_coef = coef(2:end, :);
save('DCAC.mat', 'DC_coef', 'AC_coef');
DC_coef = [2 * DC_coef(1), DC_coef(1:end - 1)] - DC_coef;

dc_block_process = @(data) DC_process(data, DCTAB);
DC = arrayfun(dc_block_process, DC_coef, 'UniformOutput', false);
DC = cell2mat(DC);

ZRL = [1 1 1 1 1 1 1 1 0 0 1];
EOB = [1 0 1 0];
AC = [];
for i = 1:blocks
    block = AC_coef(:, i);
    while(true)
        % find first non-zero coefficient index
        [c_ind, ~, c_mag] = find(block, 1);
        if(isempty(c_ind))
            break;
        end
        c_run = c_ind - 1;
        while(c_run > 15)
            c_run = c_run - 16;
            AC = [AC, ZRL];
        end
        c_size = ceil(log2(abs(c_mag)+1));
        huffman = ACTAB(c_run * 10 + c_size, ...
                         4:ACTAB(c_run * 10 + c_size, 3) + 3);
        bin_mag = dec2bin_vec(c_mag);
        AC = [AC, huffman, bin_mag];
        block(1:c_ind) = [];
    end
    AC = [AC, EOB];
end

    function output = block_process(input, QTAB, zigzag_ind)
    C = dct_2(input);
    C_quant = round(C ./ QTAB);
    output = C_quant(zigzag_ind)';
    end

    function bin_vec = dec2bin_vec(dec_int)
        if(dec_int > 0)
            bin_vec = split(dec2bin(dec_int), '');
            bin_vec = str2double(bin_vec(2:end - 1))';
        elseif(dec_int == 0)
            bin_vec = [];
        else
            bin_vec = dec2bin(bitcmp(abs(dec_int), 'uint16'));
            bin_vec = split(bin_vec(end - size(dec2bin(abs(dec_int)), 2) + 1 : end), '');
            bin_vec = str2double(bin_vec(2:end - 1))';
        end
    end

    function output = DC_process(input, DCTAB)
        category = ceil(log2(abs(input)+1)) + 1;
        huffman_code = DCTAB(category, ...
                             2:DCTAB(category, 1) + 1);
        dc_bin_mag = dec2bin_vec(input);
        output = [huffman_code, dc_bin_mag];
    end
end

