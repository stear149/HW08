%==========================================================================
% function [D] = computeDepth(v, r)
%
% Input Arguments:
% v is the volume of water in the pond. v is a scalar. v has units of [m^3]
% r is the base radius of the pond. r is a scalar. r has units of [m]
%
% Returns:
% d is the depth of the pond at volume v. d is a scalar. d has units of [m]
%
% Author: Group I
%
% Version 29 Oct. 2025
%==========================================================================
function[d] = computeDepth(v, r)
    if v > 0
        d = (r^3/64 + (3*v)/(16*pi))^(1/3) - r/4;
    else
        d = 0;
    end
end
