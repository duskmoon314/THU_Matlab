clear;
close all;
clc;

M = reshape(1:64, [8 8]);
out_for = zigzag_for(M);
out_amro = zigzag_amro(M);
out_luis = zigzag_luis(M);
disp("for-amro");
disp(norm(out_for - out_amro));
disp("amro-luis");
disp(norm(out_amro - out_luis));

function output = zigzag_amro(input)
    ind = reshape(1:numel(input), size(input));
    ind = fliplr( spdiags( fliplr(ind) ) );
    ind(:,1:2:end) = flipud( ind(:,1:2:end) );
    ind(ind==0) = [];
    output = input(ind);
end

function output = zigzag_luis(input)
    [r, c] = size(input);
    M = bsxfun(@plus, (1:r).', 0:c-1);
    M = M + bsxfun(@times, (1:r).'/(r+c), (-1).^M);
    [~, ind] = sort(M(:));
    output = input(ind).';
end

function output = zigzag_for(input)
    [r, c] = size(input);
    output = zeros(1, r * c);
    i = 1;
    j = 1;
    cnt = 1;
    
    while ((i <= r) && (j <= c))
        output(cnt) = input(i, j);
        cnt = cnt + 1;
        if (mod(i + j, 2)) % odd => down
            if (i == r)
                j = j + 1;
            elseif (j == 1)
                i = i + 1;
            else
                i = i + 1;
                j = j - 1;
            end
        else % even => up
            if (j == c)
                i = i + 1;
            elseif (i == 1)
                j = j + 1;
            else
                i = i - 1;
                j = j + 1;
            end
        end
    end
end