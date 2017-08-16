function dfdt = virtualInertia(t, f, A, B, M)

if (t >= 0.05) && (t <= 0.1)
    p = -1;
else
    p = 0;
end

% Control Variable:
% u = - M*dfdt

dfdt = (A*f + B*p)/(M+1); % Evaluate ODE at times t
