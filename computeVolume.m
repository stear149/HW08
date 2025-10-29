%==========================================================================
% function [v] = computeVolume(d, r)
%
% Input Arguments:
% d is the depth of the pond. d is a scalar. d has units of [m]
% r is the base radius of the pond. r is a scalar. r has units of [m]
%
% Returns:
% v is the volume of water in the pond. v is a scalar. v has units of [m^3]
%
% Author: Group I
% Version 29 Oct. 2025
%==========================================================================
function [v] = computeVolume(d, r)

    v = pi*(d*(3*r^2 + 12*d*r + 16*d^2))/3;

end
