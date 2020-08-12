clear;
close all;
clc;

b = 1;
a = [1, -1.3789, 0.9506];
e = varied_unit_samples(8000, 5);

s = filter(b, a, e);
s = s / max(abs(s));

sound([e, s], 8000);

figure;
subplot(2, 1, 1);
plot(e);
title('激励');
subplot(2, 1, 2);
plot(s);
title('滤波结果');

L = length(e);

z_e = abs(fft(e) / L);
z_e = z_e(1 : L / 2 + 1);
z_e(2 : end - 1) = 2 * z_e(2 : end - 1);

z_s = abs(fft(s) / L);
z_s = z_s(1 : L / 2 + 1);
z_s(2 : end - 1) = 2 * z_s(2 : end - 1);

figure;
subplot(2, 1, 1);
plot(8000 * (0 : (L / 2)) / L, z_e);
title('激励频域');
subplot(2, 1, 2);
plot(8000 * (0 : (L / 2)) / L, z_s);
title('滤波频域');