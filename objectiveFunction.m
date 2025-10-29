%--------------------------------------------------------------------------
% FUNCTION: objectiveFunction
%
% This function serves as the objective for the optimization. It:
% 1. Enforces the 1m accuracy constraint on radii (r) by rounding.
% 2. Calls solvePond with the design variables.
% 3. Calculates a severe penalty if the hydraulic constraints (Max Depth 
%    or Max Outflow) are violated, ensuring the optimizer only selects 
%    feasible designs.
% 4. Returns the total objective value: Area + Penalty.
%
% Syntax:
%   [objectiveValue] = objectiveFunction(x)
%
% Inputs:
%   x (1x6 vector): The vector of design variables:
%                   x = [ra, rb, rc, La, Lb, Lc]
%
% Outputs:
%   objectiveValue (scalar): The total area plus any constraint penalty.
%
%--------------------------------------------------------------------------
function [objectiveValue] = objectiveFunction(x)

    % --- Optimization Parameters (Constraints for Penalty) ---
    dMax = 2.7;       % Max allowable depth [m] 
    QMaxAllowable = 1.8; % Max allowable outflow [m^3/s]
    
    % Penalty magnitude: A large value (1 million) ensures that any infeasible 
    % solution is immediately penalized far above any feasible area.
    PENALTY_MAGNITUDE = 1e6; 

    % --- 1. Enforce Discreteness Constraint for r values (1m accuracy) ---
    % r = [ra, rb, rc] must be rounded to the nearest integer.
    r_rounded = round(x(1:3));
    L = x(4:6); % L = [La, Lb, Lc] are kept as-is 

    % --- 2. Call the simulation function (plotting suppressed) ---
    % We use the solvePondForOptimization which allows disabling plots.
    try
        [maxTotalArea, maxOutflow, maxDepth] = solvePondForOptimization(r_rounded, L, false);
    catch 
        % Assign a high cost if the ODE solver fails for stability issues
        objectiveValue = 1e12;
        return;
    end
    
    % --- 3. Calculate Penalty based on Constraints (Max Outflow & Max Depth) ---
    penalty = 0;
    
    % Constraint 1: Max Outflow from Pond Gamma
    % maxOutflow must be <= QMaxAllowable 
    if maxOutflow > QMaxAllowable
        % Penalty proportional to the magnitude of the violation
        violation = maxOutflow - QMaxAllowable;
        penalty = penalty + PENALTY_MAGNITUDE * violation;
    end

    % Constraint 2: Max Depth for Ponds Alpha, Beta, and Gamma
    % All maxDepth elements must be <= dMax
    depthViolation = max(maxDepth) - dMax;
    if depthViolation > 0
        % Penalty proportional to the largest depth violation
        penalty = penalty + PENALTY_MAGNITUDE * depthViolation;
    end
    
    % --- 4. Return the Objective Value ---
    % The optimizer minimizes this value. It will choose the smallest area 
    % among all solutions where penalty is zero (i.e., feasible solutions).
    objectiveValue = maxTotalArea + penalty;
end