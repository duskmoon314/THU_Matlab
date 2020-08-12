clear;
close all;
clc;

sig_200 = unit_samples(8000, 440, 10);
sound(sig_200);

sig_300 = unit_samples(8000, 300, 10);
sound(sig_300);