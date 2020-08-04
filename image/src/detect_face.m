function candidates = detect_face(img, color_hist, L, blk_size, stride, threshold, k)
%DETECT_FACE detect faces in img
% param img: image matrix
% param color_histogram: pretrained standard color histogram
% param L: color histogram's L
% param blk_size: block size, suspect face in blocks [b_h, b_w]
% param stride: sliding stride [h_stride, w_stride]
% param threshold: distance threshold
% param k: return top k candidates
% return candidates: N * 3 (x, y, dist) table

[h, w, c] = size(img);
assert(c == 3, 'img should have 3 channels, i.g. RGB');
img = double(img);

hh = floor((h - blk_size(1)) / stride(1) + 1);
ww = floor((w - blk_size(2)) / stride(2) + 1);

candidates = zeros(hh * ww, 3);
% start 0 => easy count
for j = 0 : ww - 1
    for i = 0 : hh - 1
        blk = img(i * stride(1) + 1 : i * stride(1) + blk_size(1), ...
                  j * stride(2) + 1 : j * stride(2) + blk_size(2), :);
        blk_hist = color_histogram(blk, L);
        distance = 1 - sum(sqrt(blk_hist .* color_hist));
        candidates(sub2ind([hh, ww], i + 1, j + 1), :) = ...
            [i * stride(1) + 1, j * stride(2) + 1, distance];
    end
end

candidates = candidates(candidates(:, 3) < threshold, :);
candidates = topkrows(candidates, k, 3, 'ascend');

candidates = flip(candidates(:, 1:2), 2); % [col_ind, row_ind]
candidates(:, 3) = blk_size(2); % col_blk_size
candidates(:, 4) = blk_size(1); % row_blk_size
% remove recint==true blocks
i = 1;
while ( i <= size(candidates, 1))
    j = i + 1;
    while (j <= size(candidates, 1))
        if(rectint(candidates(i, :), candidates(j, :)))
            candidates(j, :) = [];
        else
            j = j + 1;
        end
    end
    i = i + 1;
end
end

