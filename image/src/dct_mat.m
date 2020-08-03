function D = dct_mat(N)
% DCT_MAT DCT N * N operator
% param N: width, height of the piece
% return D: N * N square matrix

t = 0 : N - 1;
D = cos(t' * (2 * t + 1) * pi / (2 * N));
D(1,:) = sqrt(0.5);
D = D * sqrt(2 / N);
end