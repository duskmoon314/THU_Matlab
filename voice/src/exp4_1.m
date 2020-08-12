clear;
close all;
clc;

b = 1;
a = [1, -1.3789, 0.9506];

rot_angle = 150 * 2 * pi / 8000;

[z, p, k] = tf2zpk(b, a);
p = p .* exp(1i * sign(imag(p)) * rot_angle);

[b, a] = zp2tf(z, p, k);