clear;
close all;
clc;

color_hist = load('color_hist.mat');
img = imread('../assets/Arsenal.jpg');

stride = [5, 5];

img_rotate = imrotate(img, 90);
img_resize = imresize(img, [size(img, 1), size(img, 2) * 2]);
img_adjust = imadjust(img, [.1 .15 0; .85 .9 1]);

candidates_rotate = detect_face(img_rotate, color_hist.vec_3, 3, [25, 30], stride, 0.4, 100);
roi_img_rotate = insertShape(img_rotate, 'Rectangle', candidates_rotate, 'Color', 'red');
candidates_resize = detect_face(img_resize, color_hist.vec_3, 3, [30, 50], stride, 0.4, 100);
roi_img_resize = insertShape(img_resize, 'Rectangle', candidates_resize, 'Color', 'red');
candidates_adjust = detect_face(img_adjust, color_hist.vec_3, 3, [30, 25], stride, 0.4, 100);
roi_img_adjust = insertShape(img_adjust, 'Rectangle', candidates_adjust, 'Color', 'red');

figure('Name', 'Exercise 4-3', 'NumberTitle', 'off');
subplot(1,3,1);
imshow(uint8(roi_img_rotate));
subplot(1,3,2);
imshow(uint8(roi_img_resize));
subplot(1,3,3);
imshow(uint8(roi_img_adjust));

imwrite(roi_img_rotate, '../assets/4_3_rotate.png');
imwrite(roi_img_resize, '../assets/4_3_resize.png');
imwrite(roi_img_adjust, '../assets/4_3_adjust.png');