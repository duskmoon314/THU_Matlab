function signal = unit_samples(sample_freq, freq, duration)
%UNIT_SAMPLES Generate an array of unit samples
% param sample_freq: sample frequency, F_s
% param freq: unit samples frequency
% param duration: duration time of unit samples, second
% return signal: a vector

signal = zeros(1, round(sample_freq * duration));
NS = round(freq * duration);
N = round(sample_freq / freq);

i = 0 : NS - 1;
signal(i * N + 1) = 1;
end

