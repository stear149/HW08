%==========================================================================
% function [Q] = computeQin(t)
%
% Input Argument:
% t is the time since the beginning of the rainfall event. t is a scalar. 
% t has units of [s]
%
% Returns:
% Q is the inflow discharge to the pond at time t. Q is a scalar. 
% Q has units of [m3/s]
%
% Author: Group I
%
% Version 29 Oct. 2025
%==========================================================================
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
