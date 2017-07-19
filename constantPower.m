function dfdt = constantPower(t, f, A, B, q)

if (t >= 0.05) && (t <= 0.1)
    p = 20*(t - 0.05);
elseif (t > 0.15) && (t <= 0.2)
    p = -20*(t - 0.15);
elseif (t > 0.25) && (t <= 0.3)
    p = 1;
elseif (t > 0.35) && (t <= 0.4)
    p = -1;
else
    p = 0;
end



% Control Variable:
% u = q

dfdt = (A*f + B*(p + q)); % Evaluate ODE at times t