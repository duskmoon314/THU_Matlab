clear;
close all;
clc;

r = roots([1, -1.3789, 0.9506]);
Omega = abs(angle(r(1)));

b = 1;
a = [1, -1.3789, 0.9506];
% a = [1,-1.207283861048186,0.950600000000000]; % 4_1 coefficient
figure;
zplane(b, a);
title('零极点分布');

figure;
freqz(b, a);
title('频率响应');

figure;
impz(b, a);
title('单位样值响应 impz');

x = zeros(1, 100);
x(1) = 1;
figure;
y = filter(b, a, x);
stem(1:100, y);
title('单位样值响应 filter');
xlabel('n (samples)');
ylabel('Amp');