function dfdt = constantPower(t, f, A, B, q)

if (t >= 1)
    p = -0.5;
else
    p = 0;
end

% Control Variable:
% u = q

dfdt = (A*f + B*(p + q)); % Evaluate ODE at times t