% swing.m
% Megan Swanson
% SUPERB Project 2017
%
%       This script uses the swing equation to model the frequency response
%       of a power system after a loss of generation.
%
% http://matlab.cheme.cmu.edu/2011/08/09/phase-portraits-of-a-system-of-odes/

clear all; close all;

%% Plot p.u. disturbance function

syms x
p = piecewise(10<x<20, 0.1*(x-10), 30<x<40, -0.1*(x-30), 50<x<60, 1, 70<x<80, -1, 0);

figure(1)
subplot(2,1,1)
fplot(p);
xlim([0, 100])
ylim([-1, 1])
grid on

%% Plot Swing eq no control
Hvec = [0.01 0.1 1 6 8 10];

%%%% Constants %%%%
f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 2;          % power generation set point
R = 15;         % droop coefficient
M = 0.15;       % virtual inertia
% Values from: https://mallada.ece.jhu.edu/pubs/2016-M-CDC.pdf


%%%% Functions %%%%
TSPAN = [0 100];
IC = 0;         % Initial Condition: delta_f(t=0) = 0;

for ii=1:length(Hvec)
    H = Hvec(ii)    % inertia constant
    
    %%%% Coefficients %%%%
    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));

    
    % Solve ODE
    [T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);

    figure(1)
    subplot(2,1,2)
    hold on

    if ii == 0
        plot(T1, F1, 'r:');
    elseif ii == 1
        plot(T1, F1, 'g--');
    elseif ii == 2
        plot(T1, F1, 'c-.');
    elseif ii == 3
        plot(T1, F1, 'b-');
    elseif ii == 4 
        plot(T1, F1, 'm:');
    else
        plot(T1, F1, 'k--');
    end
    
  %  legend(num2str(Hvec(0)), num2str(Hvec(1)), num2str(Hvec(2)), num2str(Hvec(3)), num2str(Hvec(4)), num2str(Hvec(5)));

%% No Control
    figure(2)
    hold on

    if ii == 0
        subplot(2,2,1)
        hold on
        plot(T1, F1, 'r:');

    elseif ii == 1
        subplot(2,2,1)
        hold on
        plot(T1, F1, 'g--');

    elseif ii == 2
        subplot(2,2,1)
        hold on
        plot(T1, F1, 'c-.');

    elseif ii == 3
        subplot(2,2,1)
        hold on
        plot(T1, F1, 'b-');

    elseif ii == 4 
        subplot(2,2,1)
        hold on
        plot(T1, F1, 'm:');

    else
        subplot(2,2,1)
        hold on
        plot(T1, F1, 'k--');

    end
end
%ylim([-1 1])
hold off

%% Constant Power
for ii=1:length(Hvec)
    H = Hvec(ii)    % inertia constant
    
    %%%% Coefficients %%%%
    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));

    [T2, F2] = ode45(@(t,f) constantPower(t, f, A, B, q), TSPAN, IC);
    
    figure(2)
    hold on

    if ii == 0
        subplot(2,2,2)
        hold on
        plot(T2, F2, 'r:');

    elseif ii == 1
        subplot(2,2,2)
        hold on
        plot(T2, F2, 'g--');

    elseif ii == 2
        subplot(2,2,2)
        hold on
        plot(T2, F2, 'c-.');

    elseif ii == 3
        subplot(2,2,2)
        hold on
        plot(T2, F2, 'b-');

    elseif ii == 4 
        subplot(2,2,2)
        hold on
        plot(T2, F2, 'm:');

    else
        subplot(2,2,2)
        hold on
        plot(T2, F2, 'k--');
    end
end


%% Droop Control
for ii=1:length(Hvec)
    H = Hvec(ii)    % inertia constant
    
    %%%% Coefficients %%%%
    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));

    [T3, F3] = ode45(@(t,f) droopControl(t, f, A, B, q, R), TSPAN, IC);
    
    figure(2)
    hold on

    if ii == 0
        subplot(2,2,3)
        hold on
        plot(T3, F3, 'r:');

    elseif ii == 1
        subplot(2,2,3)
        hold on
        plot(T3, F3, 'g--');

    elseif ii == 2
        subplot(2,2,3)
        hold on
        plot(T3, F3, 'c-.');

    elseif ii == 3
        subplot(2,2,3)
        hold on
        plot(T3, F3, 'b-');

    elseif ii == 4 
        subplot(2,2,3)
        hold on
        plot(T3, F3, 'm:');

    else
        subplot(2,2,3)
        hold on
        plot(T3, F3, 'k--');
    end
end
%ylim([-1 1])

%%
for ii=1:length(Hvec)
    H = Hvec(ii)    % inertia constant
    
    %%%% Coefficients %%%%
    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));

    [T4, F4] = ode45(@(t,f) virtualInertia(t, f, A, B, q, R, M), TSPAN, IC);
    
    figure(2)
    hold on

    if ii == 0
        subplot(2,2,4)
        hold on
        plot(T4, F4, 'r:');

    elseif ii == 1
        subplot(2,2,4)
        hold on
        plot(T4, F4, 'g--');

    elseif ii == 2
        subplot(2,2,4)
        hold on
        plot(T4, F4, 'c-.');

    elseif ii == 3
        subplot(2,2,4)
        hold on
        plot(T4, F4, 'b-');

    elseif ii == 4 
        subplot(2,2,4)
        hold on
        plot(T4, F4, 'm:');

    else
        subplot(2,2,4)
        hold on
        plot(T4, F4, 'k--');
    end
end
%ylim([-1 1])

