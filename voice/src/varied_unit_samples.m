function signal = varied_unit_samples(sample_freq, duration)
%VARIED_UNIT_SAMPLES generate varied unit samples
% param sample_freq: sample frequency, F_s
% param duration: duration time of unit samples, second
% return signal: a vector

sig_len = round(sample_freq * duration);

signal = zeros(1, sig_len);

pos = 1; % pos index
while pos <= sig_len
    signal(pos) = 1;
    m = ceil(pos / (0.01 * sample_freq));
    PT = 80 + 5 * mod(m, 50);
    pos = pos + PT;
end
end

