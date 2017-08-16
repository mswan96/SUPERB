% virtualInertia.m
% Megan Swanson
% SUPERB Project 2017
%
%       Swing equation with Virtual Inertia control variable. Takes 
%       coefficients A and B and virtual inertia value M as inputs 
%       and solves with respect to the step disturbance p.

function dfdt = virtualInertia(t, f, A, B, M)

% Step disturbance
if (t >= 0.05) && (t <= 0.1)
    p = -1;
else
    p = 0;
end

% Control Variable:
% u = - M*dfdt

dfdt = (A*f + B*p)/(M+1); % Evaluate ODE at times t
