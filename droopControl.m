function dfdt = droopControl(t, f, A, B, q, R)

if (t >= 0.05) && (t <= 0.1)
    p = -1;
else
    p = 0;
end


% Control Variable:
% u = q + (1/R)*f

dfdt = ((A - B*(1/R))*f + B*(p + q)); % Evaluate ODE at times t