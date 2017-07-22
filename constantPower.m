function dfdt = constantPower(t, f, A, B, q)

if (t >= 0.05) && (t <= 0.1)
    p = -1;
else
    p = 0;
end


% Control Variable:
% u = q

dfdt = (A*f + B*(p + q)); % Evaluate ODE at times t