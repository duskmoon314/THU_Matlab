function [img] = JPEG_decode(DC, AC, height, width, QTAB, ACTAB, zigzag_inv)
% JPEF_DECODE Decode JPEG
% param DC: DC encoded
% param AC: AC encoded
% param height: img height
% param width: img width
% param QTAB: quantization matrix
% param DCTAB: DC code table
% param ACTAB: AC code table
% param zigzag_inv: Zig-Zag inv index
% return img: pictuer matrix

blocksize = ceil([height, width] / 8);
% h_pad = blocksize(1) * 8;
% w_pad = blocksize(2) * 8;
blocks = blocksize(1) * blocksize(2);
DC_coeff = zeros(1, blocks);
AC_coeff = zeros(63, blocks);

cnt = 1;
while(cnt <= blocks)
    if(all(DC(1:2) == [0 0]))
        % category 0 mag 0
        DC(1:2) = [];
    else
        % find zero index
        zero_ind = find(DC==0, 1);
        if(zero_ind < 4)
            huffman_code = DC(1:3);
            DC(1:3) = [];
            zero_ind = bin2dec(strjoin(string(huffman_code), '')) - 1;
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

ZRL = [1 1 1 1 1 1 1 1 0 0 1];
EOB = [1 0 1 0];
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

% DCAC = load('DCAC.mat');
% image(DC_coeff - DCAC.DC_coef);
% image(AC_coeff - DCAC.AC_coef);

coef = [DC_coeff; AC_coeff];

inv_zigzag = @(block_struct) ...
    idct2(reshape(block_struct.data(zigzag_inv), [8 8]) .* QTAB);
coef = reshape( ...
       permute( ...
       reshape(coef, 64, blocksize(2), []), ...
           [2 1 3]), ...
               blocksize(2), [])';
inv_img = blockproc(coef, [64, 1], inv_zigzag);
img = uint8(inv_img(1:height, 1:width) + 128);

    function dec_int = bin_vec2dec(bin_vec)
        bin_str = strjoin(string(bin_vec), '');
        if (bin_vec(1) == 1)
            dec_int = bin2dec(bin_str);
        else
            dec_int = bin2dec(bin_str);
            dec_int = 1 + dec_int - 2^strlength(bin_str);
        end
    end
end

