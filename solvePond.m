%------------------------------------------------------------------------------
% [maxTotalArea, maxOutflow, maxDepth] = solvePond(r, L)
%
% Arguments:
% 
%   r = [ra, rb, rc]    A 3 x 1 matrix of r values for the bottom of the
%                       pond
%   L = [La, Lb, Lc]    A 3 x 1 matrix of L values for the lenght of the
%                       wier
%
% Returns
%   maxTotalArea        Maximum of total area of pond A and B
%   maxOutflow          Maximum of out folow from pond B
%   maxDepth            Maximum depth of ponds A and B
%
%
% Author:
%   Evan M. Stearns 
%   Owen Haberstroh
%   Lily Wilkerson
%   (Group I)
%   University of Minnesota
%
%    Current Best
%    r = [1,72,84]
%    L = [14.991,.393,.449]
%    Amax = [49770]
%
% Version:
%   28 October 2025
% 
%------------------------------------------------------------------------------

function [maxTotalArea, maxOutflow, maxDepth] = solvePond(r, L)
    ra = r(1);
    rb = r(2);
    rc = r(3);
    La = L(1); 
    Lb = L(2); 
    Lc = L(3); 
    
    assert(ra <= 75,"<ra> must be less than 75");
    assert(rb <= 75,"<rb> must be less than 75");
    assert(rc <= 95,"<rc> must be less than 75");

    plot_output = true;
    dMax = 2.7; % [m]
    dMin = 1; % [m]
    QMaxAllowable = 1.8; % [m^3/s]

    % Initial volume V0 is the volume at minimum depth D=1m for each pond.
    Vo = [computeVolume(dMin, ra); computeVolume(dMin, rb); computeVolume(dMin, rc)];

    % Use Tspan from the problem statement: 0 to 24 hours (86400 s)
    Tspan = linspace(0, 24*60*60, 10001); 
    
    % Solve the ODE system
    [T,V] = ode45(@(t,V) computeVdot(t, V, r, L), Tspan, Vo);
    
    % --- Post-Processing: Time-Series Calculations ---
    Qin = arrayfun(@(t) computeQin(t), T, 'UniformOutput', false);
    Qin = cell2mat(Qin);
    Qin = reshape(Qin, 2, length(T));


    % Pond 1 (Alpha)
    QinA = Qin(1,:);
    Va = V(:,1);
    Da = arrayfun(@(v) computeDepth(v, ra), Va);
    QoutA = arrayfun(@(d) computeQout(d, La), Da);
    AreaA = pi * (ra + 4 * Da).^2; 
    
    % Pond 2 (Beta)
    QinB = Qin(2,:);
    Vb = V(:,2);
    Db = arrayfun(@(v) computeDepth(v, rb), Vb);
    QoutB = arrayfun(@(d) computeQout(d, Lb), Db);    
    AreaB = pi * (rb + 4 * Db).^2; 

    % Pond 3 (Gamma)
    QinC = QoutA + QoutB;
    Vc = V(:,3);
    Dc = arrayfun(@(v) computeDepth(v, rc), Vc);
    QoutC = arrayfun(@(d) computeQout(d, Lc), Dc);    
    AreaC = pi * (rc + 4 * Dc).^2; 
    
    % --- 1. Calculate Required Output Variables ---

    % Maximum depths (a 2x1 matrix)
    maxDepth = [max(Da); max(Db);max(Dc)]; 
    
    % Maximum outflow from the second pond (Q_out_Gamma)
    maxOutflow = max(QoutC); 
    
    % Maximum total combined surface area (TotalArea = A_a + A_b)
    maxTotalArea = max(AreaA) + max(AreaB) + max(AreaC);


    
    % --- 2. Generate Graphical Output ---
    if plot_output
        tic

        figure; % Open a new figure window

        % Plot 1 (Location 1: Upper-Left) Flow vs. Time
        subplot(2, 2, 1);
        plot(T, QinA, 'b-', 'LineWidth', 2); hold on;
        plot(T, QoutA, 'b--', 'LineWidth',2);
        plot(T, QinB, 'g-', 'LineWidth', 2);
        plot(T, QoutB, 'g--', 'LineWidth', 2);
        plot(T, QinC, 'r-.', 'LineWidth', 2);
        plot(T, QoutC, 'r--', 'LineWidth', 2); hold off;
        title('Flow vs. Time');
        xlabel('time [s]');
        ylabel('Flow [m^3/s]');
        legend('inflow A', 'outflow A', 'inflow B', 'outflow B', 'inflow C','outflow C');
        grid on;

        % Plot 2 (Location 2: Upper-Right) Depth vs. Time
        subplot(2, 2, 2);
        plot(T, Da, 'b-', 'LineWidth', 2); hold on;
        plot(T, Db, 'r--', 'LineWidth', 2);
        plot(T, Dc, 'm:', 'LineWidth', 2); hold off; % Added Pond Gamma Depth
        title('Depth vs. Time');
        xlabel('time [s]');
        ylabel('Depth [m]');
        legend('Pond \alpha Depth', 'Pond \beta Depth', 'Pond \gamma Depth', 'Location', 'northeast');
        % Add a line at D=1m (minimum depth) for reference
        grid on;

        % Plot 3 (Location 3: Lower-Left) Surface Area vs. Time
        subplot(2, 2, 3);
        plot(T, AreaA, 'b-', 'LineWidth', 2); hold on;
        plot(T, AreaB, 'r--', 'LineWidth', 2);
        plot(T, AreaC, 'm:', 'LineWidth', 2); hold off; % Added Pond Gamma Area
        title('Surface Area vs. Time');
        xlabel('time [s]');
        ylabel('Area [m^2]');
        legend('Pond \alpha Area', 'Pond \beta Area', 'Pond \gamma Area', 'Location', 'northeast');
        grid on;

        % Plot 4 (Location 4: Lower-Right) Volume vs. Time
        subplot(2, 2, 4);
        plot(T, V(:, 1), 'b-', 'LineWidth', 2); hold on;
        plot(T, V(:, 2), 'r--', 'LineWidth', 2);
        plot(T, V(:, 3), 'm:', 'LineWidth', 2); hold off; % Added Pond Gamma Volume
        title('Volume vs. Time');
        xlabel('time [s]');
        ylabel('Volume [m^3]');
        legend('Pond \alpha Volume', 'Pond \beta Volume', 'Pond \gamma Volume', 'Location', 'northeast');
        grid on;

        toc
    end

    % Check for valid design
    try
        validityCheck(maxOutflow, QMaxAllowable, maxDepth, dMax);
    catch
        % If no function is found, do nothing
    end

end
