% mySwing.m
% Megan Swanson
% SUPERB Project 2017
%
%       Swing equation with no control. Takes coefficients A and B as
%       inputs and solves with respect to the step disturbance p.

function dfdt = mySwing(t, f, A, B)

% Step disturbance
if (t >= 0.05) && (t <= 0.1)
    p = -1;
else
    p = 0;
end

% Control Variable:
% u = 0

dfdt = (A*f + B*p); % Evaluate ODE at times t
