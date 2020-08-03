function color_histogram = color_histogram(img, L)
%COLOR_HISTOGRAM generate color histogram of img
% param img: image matrix
% param L: color bit length <= 8
% return color_histogram: vector, histogram

[~, ~, c] = size(img);
assert(c == 3, 'img should have 3 channels, i.g. RGB');
bins = 0 : 2 ^ (3 * L);

img = floor(double(img) / 2 ^ (8 - L));
pixel = img(:, :, 1) * 2 ^ (2 * L) + img(:, :, 2) * 2 ^ L + img(:, :, 3);
pixel = reshape(pixel, 1, []);

color_histogram = histcounts(pixel, bins) * 3 / numel(img);
end

