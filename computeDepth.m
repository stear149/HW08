function[d] = computeDepth(v, r)
    if v > 0
        d = (r^3/64 + (3*v)/(16*pi))^(1/3) - r/4;
    else
        d = 0;
    end
end