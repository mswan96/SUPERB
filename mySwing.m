function dfdt = mySwing(t, f, A, B)

if (t >= 1)
    p = -0.5;
else
    p = 0;
end

% Control Variable:
% u = 0

dfdt = (A*f + B*p); % Evaluate ODE at times t