function dfdt = virtualInertia(t, f, A, B, q, R, M)

if (t >= 1) 
    p = -0.5;
else
    p = 0;
end

% Control Variable:
% u = q - (1/R)*f - M*dfdt

dfdt = ((A - (B*(1/R)))*f + B*(p + q))/(M+1); % Evaluate ODE at times t