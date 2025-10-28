function[Q] = computeQout(d, L)
    C = 1.84;
    if d <= 1
        Q = 0;
    else
        Q = C*L*(d-1)^(3/2);
    end
end