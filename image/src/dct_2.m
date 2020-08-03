function C = dct_2(P)
% DCT_2 2D discrete cosine transform
% param P: square matrix
% return C: transformed result

[w, h] = size(P);
assert(w==h, "P must be a square matrix");
P = double(P);
D = dct_mat(w);
C = D * P * D';
end

