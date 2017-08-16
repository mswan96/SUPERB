% both.m
% Megan Swanson
% SUPERB Project 2017
%
%       Swing equation with Droop Control and Virtual Inertia control variables. 
%       Takes coefficients A and B and droop coefficient R and virtual inertia 
%       value M as inputs and solves with respect to the step disturbance p.

function dfdt = both(t, f, A, B, R, M)

% Step disturbance
if (t >= 0.05) && (t <= 0.1)
    p = -1;
else
    p = 0;
end

% Control Variable:
% u = -1*(1/R)*f - M*dfdt

dfdt = ((A - (B*(1/R)))*f + B*p)/(M+1); % Evaluate ODE at times t
