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
