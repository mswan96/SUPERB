function dfdt = mySwing(t, f, pt, p, C, D)
% p = interp1(pt, p, t); %Interpolate the data set (pt, p) at times t

% if (t >= 3) && (t <= 4)
%     p_val = 1;
% else
%     p_val = 0;
% end

p_val = piecewise(t>=3, 1, t<=4, 1, 0);

%p_val = floor()
dfdt = -C*((1/D)*f - p_val); % Evaluate ODE at times t