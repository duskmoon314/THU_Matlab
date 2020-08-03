clear;
close all;
clc;

color_hist = load('color_hist.mat');
img = imread('../assets/Arsenal.jpg');
blk_size = [30, 25];
stride = [5, 5];

candidates_3 = detect_face(img, color_hist.vec_3, 3, blk_size, stride, 0.4, 50);
roi_img_3 = insertShape(img, 'Rectangle', candidates_3, 'Color', 'red');

candidates_4 = detect_face(img, color_hist.vec_4, 4, blk_size, stride, 0.4, 100);
roi_img_4 = insertShape(img, 'Rectangle', candidates_4, 'Color', 'red');

candidates_5 = detect_face(img, color_hist.vec_5, 5, blk_size, stride, 0.6, 100);
roi_img_5 = insertShape(img, 'Rectangle', candidates_5, 'Color', 'red');

imshow(roi_img_3);
imshow(roi_img_4);
imshow(roi_img_5);

imwrite(roi_img_3, '../assets/4_2_L3.png');
imwrite(roi_img_4, '../assets/4_2_L4.png');
imwrite(roi_img_5, '../assets/4_2_L5.png');