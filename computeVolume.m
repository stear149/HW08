function [v] = computeVolume(d, r)

    v = pi*(d*(3*r^2 + 12*d*r + 16*d^2))/3;

end