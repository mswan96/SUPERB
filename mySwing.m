function dfdt = mySwing(t, f, A, B)

if (t >= 0.05) && (t <= 0.1)
    p = -1;
else
    p = 0;
end

% Control Variable:
% u = 0

dfdt = (A*f + B*p); % Evaluate ODE at times t