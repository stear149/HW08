function [Q] = computeQin(t)
   tau1 = t/20000;
   tau2 = t/40000;
    if t < 0
        Qin1 = 0;
    elseif t < 20000
        Qin1 = (150*tau1^2)*(1-tau1)^3;
    else
        Qin1 = 0;
    end

    if t < 0
        Qin2 = 0;
    elseif t < 40000
        Qin2 = (225*tau2^2)*(1-tau2)^5;
    else
        Qin2 = 0;
    end

    Q = [Qin1; Qin2];
end