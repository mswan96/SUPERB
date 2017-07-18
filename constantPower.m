function dfdt = constantPower(t, f, A, B, q)

if (t >= 10) && (t <= 20)
    p = t - 10;
elseif (t > 30) && (t <= 40)
    p = -t + 30;
elseif (t > 50) && (t <= 60)
    p = 1;
elseif (t > 70) && (t <= 80)
    p = -1;
else
    p = 0;
end

% Control Variable:
% u = q

dfdt = (A*f + B*p - q); % Evaluate ODE at times t