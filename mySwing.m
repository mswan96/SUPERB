function dfdt = mySwing(t, f, A, B)

if (t >= 10) && (t <= 20)
    p = 0.1*(t - 10);
elseif (t > 30) && (t <= 40)
    p = -0.1*(t - 30);
elseif (t > 50) && (t <= 60)
    p = 1;
elseif (t > 70) && (t <= 80)
    p = -1;
else
    p = 0;
end

% Control Variable:
% u = 0

dfdt = (A*f + B*p); % Evaluate ODE at times t