function [img_decode, ratio, PSNR, secret_decode, code] = ...
    dct_embed_2(img, QTAB, DCTAB, ACTAB, zigzag, zigzag_inv, secret, bias, len)
%DCT_EMBED_2 embed secret into img
% param img: pictuer matrix
% param QTAB: quantization matrix
% param DCTAB: DC code table
% param ACTAB: AC code table
% param zigzag: Zig-Zag index
% param zigzag_inv: Zig-Zag inv index
% param bias: secret start index in every block
% param len: secret length per block
% return img_decode: decode pictuer matrix
% return ratio: compression ratio
% return PSNR
% return secret_decode: secret decode
% return code: DC & AC code

assert(bias + len < 66, 'secret too long in a block');

img = double(img) - 128;
[height, width] = size(img);

secret_len = length(secret);
% secret__blocks = ceil(secret_len / 8);

process = @(block_struct) block_process(block_struct.data, QTAB, zigzag);
coef = blockproc(img, [8 8], process, 'PadPartialBlocks', true);
coef = reshape(coef', size(coef, 2), 64, []);
coef = permute(coef, [2, 1, 3]);
coef = reshape(coef, 64, []);
blocks = size(coef, 2);

secret_pad = reshape([secret, zeros(1, blocks * 8 - secret_len)], 8, []);

assert(secret_len <= len * blocks, "secret length needs to be smaller than pixels");

coef(bias : bias + len - 1, :) = bitshift(bitshift(coef(bias : bias + len - 1,:), -1, 'int64'), 1, 'int64');
coef(bias : bias + len - 1, :) = coef(bias : bias + len - 1, :) + secret_pad;

% huffman encode

DC_coef = coef(1, :);
AC_coef = coef(2:end, :);
% save('DCAC.mat', 'DC_coef', 'AC_coef');
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

ratio = numel(img) * 8 / (length(DC) + length(AC));

code.DC = DC;
code.AC = AC;

% decode
blocksize = ceil([height, width] / 8);
DC_coeff = zeros(1, blocks);
AC_coeff = zeros(63, blocks);

cnt = 1;
while(cnt <= blocks)
    if(all(DC(1:2) == [0 0]))
        % category 0 mag 0
        DC(1:2) = [];
    else
        zero_ind = find(DC==0, 1);
        if(zero_ind < 4)
            huffman = DC(1:3);
            DC(1:3) = [];
            zero_ind = bin2dec(strjoin(string(huffman), '')) - 1;
        else
            DC(1:zero_ind) = [];
            zero_ind = zero_ind + 2;
        end
        mag = bin_vec2dec(DC(1:zero_ind));
        DC_coeff(cnt) = mag;
        DC(1:zero_ind) = [];
    end
    cnt = cnt + 1;
end

for i = 2:blocks
    DC_coeff(i) = DC_coeff(i - 1) - DC_coeff(i);
end

ACTAB_code = ACTAB(:, 4:19);

huffman = zeros(1, 16);
cnt = 1;
ind = 1;
while(cnt <= blocks)
    if(length(AC) > 11 && all(AC(1:11) == ZRL))
        ind = ind + 16;
        AC(1:11) = [];
    elseif(all(AC(1:4) == EOB))
        ind = 1;
        cnt = cnt + 1;
        AC(1:4) = [];
    else
        huffman(:) = 0;
        for i = 1:16
            huffman(i) = AC(i);
            idx = find(ismember(ACTAB_code, huffman, 'rows'), 1);
            if(~isempty(idx) && ACTAB(idx, 3) == i)
                AC(1:i) = [];
                break;
            end
        end
        temp = num2cell(ACTAB(idx, 1:2));
        [c_run, c_size] = deal(temp{:});
        ind = ind + c_run;
        AC_coeff(ind, cnt) = bin_vec2dec(AC(1:c_size));
        AC(1:c_size) = [];
        ind = ind + 1;
    end
end

coef = [DC_coeff; AC_coeff];
secret_decode = reshape(coef(bias : bias + len - 1, :), 1, []);
secret_decode = mod(secret_decode(1:secret_len), 2);

inv_zigzag = @(block_struct) ...
    idct2(reshape(block_struct.data(zigzag_inv), [8 8]) .* QTAB);
coef = reshape( ...
    permute( ...
    reshape(coef, 64, blocksize(2), []), ...
    [2 1 3]), ...
    blocksize(2), [])';
inv_img = blockproc(coef, [64, 1], inv_zigzag);
img_decode = uint8(inv_img(1:height, 1:width) + 128);

img = uint8(img + 128);

PSNR = 10 * log10(255^2 * height * width / norm(double(img_decode - img), 'fro')^2);

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

    function dec_int = bin_vec2dec(bin_vec)
        bin_str = strjoin(string(bin_vec), '');
        if (bin_vec(1) == 1)
            dec_int = bin2dec(bin_str);
        else
            dec_int = bin2dec(bin_str);
            dec_int = 1 + dec_int - 2^strlength(bin_str);
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