%==========================================================================
% function[Q] = computeQout(d, L)
%
% Input Arguments:
% d is the depth of water in the pond. d is a scalar. d has units of [m]
% L is the length of the weir in the pond. L is a scalar. 
% L has units of [m]
%
% Returns:
% Q is the outflow discharge from the pond at depth d. Q is a scalar. 
% Q has units of [m^3/s]
%
% Author: Group I
%
% Version 29 Oct. 2025
%==========================================================================
function[Q] = computeQout(d, L)
    C = 1.84;
    if d <= 1
        Q = 0;
    else
        Q = C*L*(d-1)^(3/2);
    end
end
