% droopControl.m
% Megan Swanson
% SUPERB Project 2017
%
%       Swing equation with Droop Control variable. Takes coefficients A and B 
%       and droop coefficient R as inputs and solves with respect to the step 
%       disturbance p.

function dfdt = droopControl(t, f, A, B, R)

% Step disturbance
if (t >= 0.05) && (t <= 0.1)
    p = -1;
else
    p = 0;
end


% Control Variable:
% u = (1/R)*f

dfdt = ((A - B*(1/R))*f + B*p); % Evaluate ODE at times t
