%--------------------------------------------------------------------------
% SCRIPT: optimizePond
%
% This script sets up and runs the optimization to find the minimum 
% maxTotalArea while satisfying the hydraulic constraints.
%
% Design Variables (x):
%   x(1) = ra (Pond Alpha radius) - Rounded to 1m accuracy
%   x(2) = rb (Pond Beta radius)  - Rounded to 1m accuracy
%   x(3) = rc (Pond Gamma radius) - Rounded to 1m accuracy
%   x(4) = La (Pond Alpha weir length) - Continuous (0.001m accuracy is set by tolerance)
%   x(5) = Lb (Pond Beta weir length)
%   x(6) = Lc (Pond Gamma weir length)
%
%--------------------------------------------------------------------------

% Clear workspace and close figures
clear; clc; close all;

% --- 1. Define Search Space Bounds (Lower and Upper) ---
% These are the physical limits for the variables.
% Constraints from solvePond.m: ra <= 75, rb <= 75, rc <= 95
% Must be positive: r > 0, L > 0
% We will use a lower bound of 1 for all variables.

% Lower Bounds: [ra, rb, rc, La, Lb, Lc]
lb = [1, 1, 1, .001, .001, .001]; 

% Upper Bounds: [ra, rb, rc, La, Lb, Lc]
% The L bounds are chosen reasonably (e.g., up to 10m weir length)
ub = [75, 75, 95, 100, 15, 15]; 

% --- 2. Initial Guess (Starting Point for search, can be random) ---
x0 = [1, 75, 95, 9, .5, .5]; 

% --- 3. Optimization Setup (Genetic Algorithm) ---

% The optimization function is the one we created.
fun = @objectiveFunction;

% Number of variables
nvars = 6;

% Use empty matrices for unused constraints (A, b, Aeq, beq, nonlcon)
A = []; b = []; Aeq = []; beq = []; nonlcon = [];

% Set Optimization Options
options = optimoptions('ga', ...
    'Display', 'iter', ... % Show iterative results
    'PopulationSize', 500, ... % Larger population for better search
    'MaxGenerations', 250, ... % Limit search time
    'PlotFcn', {@gaplotbestf}, ... % Plot best objective function value
    'UseParallel', true, ... % Use parallel computing if available (recommended)
    'FunctionTolerance', 1e-4); % Set tolerance for objective function

fprintf('Starting Genetic Algorithm Optimization...\n');
fprintf('Minimizing Area + Constraint Penalty over 6 variables.\n');

% --- 4. Run the Optimization ---
[x_optimized, fval, exitflag, output] = ga(fun, nvars, A, b, Aeq, beq, lb, ub, nonlcon, options);

% --- 5. Report Results ---

% Re-apply the rounding for final results to ensure 1m accuracy on r
r_final = round(x_optimized(1:3));
L_final = x_optimized(4:6); 

fprintf('\n\n--- OPTIMIZATION RESULTS ---\n');

if exitflag > 0
    % Rerun the simulation with the optimal, rounded parameters to get the final, 
    % unpenalized performance metrics and generate the final plot.
    [maxTotalArea, maxOutflow, maxDepth] = solvePond(r_final, L_final);

    fprintf('Optimization Finished Successfully!\n');
    fprintf('Optimal Total Area: %.2f m^2\n', maxTotalArea);
    fprintf('Maximum Outflow (must be <= 1.8 m^3/s): %.5f m^3/s\n', maxOutflow);
    
    fprintf('\nOptimal Radii (Rounded to 1m accuracy):\n');
    fprintf('  r_alpha: %d m\n', r_final(1));
    fprintf('  r_beta: %d m\n', r_final(2));
    fprintf('  r_gamma: %d m\n', r_final(3));
    
    fprintf('\nOptimal Weir Lengths (L, 0.001m accuracy):\n');
    fprintf('  L_alpha: %.3f m\n', L_final(1));
    fprintf('  L_beta: %.3f m\n', L_final(2));
    fprintf('  L_gamma: %.3f m\n', L_final(3));
    
    % The validityCheck function will print the constraint status
    validityCheck(maxOutflow, 1.8, maxDepth, 2.7);

else
    fprintf('Optimization did not converge successfully. Exit Flag: %d\n', exitflag);
    fprintf('Check your bounds, initial guess, or increase MaxGenerations.\n');
end