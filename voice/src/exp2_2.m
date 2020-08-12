clear;
close all;
clc;

sig = varied_unit_samples(8000, 10);
sound(sig, 8000);

figure;
plot((0:79999) / 8000, sig);