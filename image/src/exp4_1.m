clear;
close all;
clc;

data_dir = '../assets/Faces/';
vec_3 = zeros(1, 2 ^ 9);
vec_4 = zeros(1, 2 ^ 12);
vec_5 = zeros(1, 2 ^ 15);

datas = ls(fullfile(data_dir, '*.bmp'));
data_num = length(datas);
for i = 1 : data_num
    img = imread(fullfile(data_dir, datas(i, :)));
    vec_3 = vec_3 + color_histogram(img, 3);
    vec_4 = vec_4 + color_histogram(img, 4);
    vec_5 = vec_5 + color_histogram(img, 5);
end

vec_3 = vec_3 / data_num;
vec_4 = vec_4 / data_num;
vec_5 = vec_5 / data_num;

save('color_hist.mat', 'vec_3', 'vec_4', 'vec_5');

ind_3 = 1 : length(vec_3);
[b, g, r] = ind2sub([8, 8, 8], ind_3);
vec_3_3d = [b', g', r', vec_3(ind_3)'];

ind_4 = 1 : length(vec_4);
[b, g, r] = ind2sub([16, 16, 16], ind_4);
vec_4_3d = [b', g', r', vec_4(ind_4)'];

ind_5 = 1 : length(vec_5);
[b, g, r] = ind2sub([32, 32, 32], ind_5);
vec_5_3d = [b', g', r', vec_5(ind_5)'];



figure('Name', 'Exercise 4-1', 'NumberTitle', 'off');
subplot(2,3,1);
plot(vec_3);
xlabel('颜色索引');
ylabel('频率');
subplot(2,3,2);
plot(vec_4);
xlabel('颜色索引');
ylabel('频率');
subplot(2,3,3);
plot(vec_5);
xlabel('颜色索引');
ylabel('频率');
subplot(2,3,4);
scatter3(vec_3_3d(:, 1) * 32 - 16, ...
    vec_3_3d(:, 2) * 32 - 16, ...
    vec_3_3d(:, 3) * 32 - 16, ...
    vec_3_3d(:, 4) * 18000 + 1, ...
    vec_3_3d(:, 4), ...
    '.');
xlabel('blue');
ylabel('green');
zlabel('red');
subplot(2,3,5);
scatter3(vec_4_3d(:, 1) * 16 - 8, ...
    vec_4_3d(:, 2) * 16 - 8, ...
    vec_4_3d(:, 3) * 16 - 8, ...
    vec_4_3d(:, 4) * 27000 + 1, ...
    vec_4_3d(:, 4), ...
    '.');
xlabel('blue');
ylabel('green');
zlabel('red');
subplot(2,3,6);
scatter3(vec_5_3d(:, 1) * 8 - 4, ...
    vec_5_3d(:, 2) * 8 - 4, ...
    vec_5_3d(:, 3) * 8 - 4, ...
    vec_5_3d(:, 4) * 36000 + 1, ...
    vec_5_3d(:, 4), ...
    '.');
xlabel('blue');
ylabel('green');
zlabel('red');