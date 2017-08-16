function dfdt = both(t, f, A, B, R, M)

if (t >= 0.05) && (t <= 0.1)
    p = -1;
else
    p = 0;
end

% Control Variable:
% u = -1*(1/R)*f - M*dfdt

dfdt = ((A - (B*(1/R)))*f + B*p)/(M+1); % Evaluate ODE at times t
