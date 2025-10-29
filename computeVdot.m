%==========================================================================
% function [dv] = computeVdot(t, V, r, L)
%
% Input Arguments:
% t is the time since the beginning of the rainfall event. t is a scalar. 
% t has units of [s]
%
% V is the volume of water in the ponds. V is a (2 × 1) matrix: 
% V has units of [m3]
%
% r is a (3 x 1) matrix containing ra, rb, and rc
% ra is the base radius of the first pond. ra is a scalar. 
% ra has units of [m]
%
% rb is the base radius of the second pond. rb is a scalar. 
% rb has units of [m]
%
% rc is the base radius of the second pond. rb is a scalar. 
% rc has units of [m]
%
% L is a (3 x 1) matrix containing La, Lb, and Lc
% La is the length of the weir in the first pond. La is a scalar. 
% La has units of [m]
%
% Lb is the length of the weir in the second pond. Lb is a scalar. 
% Lb has units of [m]
%
% Lc is the length of the weir in the second pond. Lb is a scalar. 
% Lc has units of [m]
%
% Returns:
% dVdt is the first derivatives of the pond volumes with respect to time 
% dVdt is a (3 × 1) matrix: 
% dVdt(1) is the derivative for the first pond
% dVdt(2) is the derivative for the second pond. dVdt has units of [m^3/s]
% dVdt(3) is the derivative for the third pond. dVdt has units of [m^3/s]
%
% Author: Group I
%
% Version 29 Oct. 2025
%==========================================================================
function [dv] = computeVdot(t, V, r, L)
    
    Qin = computeQin(t);
    
    % --- Pond Alpha (Pond 1) ---
    Va = V(1); 
    ra = r(1);
    La = L(1);
    Da = computeDepth(Va, ra);
    Qina = Qin(1);
    Qouta = computeQout(Da, La);

    % Derivative for Pond Alpha
    dVadt = Qina - Qouta;

    % --- Pond Beta (Pond 2) ---
    Vb = V(2);
    rb = r(2);
    Lb = L(2);
    Db = computeDepth(Vb, rb);
    Qinb = Qin(2);
    Qoutb = computeQout(Db, Lb);

    % Derivative for Pond Beta
    dVbdt = Qinb - Qoutb;

    % --- Pond Gamma (Pond 3) ---
    Vc = V(3);
    rc = r(3);
    Lc = L(3);
    Dc = computeDepth(Vc, rc);
    Qinc = Qouta + Qoutb;
    Qoutc = computeQout(Dc, Lc);


    % Derivative for Pond Gamma
    dVcbt = Qinc - Qoutc;



    % dV/dt
    dv = [dVadt; dVbdt; dVcbt];
end
