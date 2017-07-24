% swing.m
% Megan Swanson
% SUPERB Project 2017
%
%       This script uses the swing equation to model the frequency response
%       of a power system after a loss of generation.
%
% http://matlab.cheme.cmu.edu/2011/08/09/phase-portraits-of-a-system-of-odes/

clear all; close all; clc;

%% Plot p.u. disturbance function

syms x
p = piecewise(0.05<x<0.1, 20*(x-0.05), 0.15<x<0.2, -20*(x-0.15), 0.25<x<0.3, 1, 0.35<x<0.4, -1, 0);

figure(1)
subplot(2,1,1)
hold on
fplot(p);
title('Disturbance p(t)');
xlabel('time (s)'); ylabel('?P_m - ?P_load');
xlim([0, 0.5])
%ylim([-1, 1])
grid on

%% Inputs
Hvec = [0.01 0.1 1 6 8 10];

%%%% Constants %%%%
f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 15;         % droop coefficient
M = 0.15;       % virtual inertia
% Values from: https://mallada.ece.jhu.edu/pubs/2016-M-CDC.pdf


%%%% Functions %%%%
TSPAN = [0 0.5];
IC = 0;         % Initial Condition: delta_f(t=0) = 0;

%% Plot Swing eq no control
for ii=1:length(Hvec)
    H = Hvec(ii)    % inertia constant
    
    %%%% Coefficients %%%%
    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));

    
    % Solve ODE
    [T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);

    figure(1)

    if ii == 1
        subplot(2,1,2)
        hold on
        plot(T1, F1, 'r:');
    elseif ii == 2
        subplot(2,1,2)
        hold on
        plot(T1, F1, 'g--');
    elseif ii == 3
        subplot(2,1,2)
        hold on
        plot(T1, F1, 'c-.');
    elseif ii == 4
        subplot(2,1,2)
        hold on
        plot(T1, F1, 'b-');
    elseif ii == 5 
        subplot(2,1,2)
        hold on
        plot(T1, F1, 'm:');
    else
        subplot(2,1,2)
        hold on
        plot(T1, F1, 'k--');
    end
end
title('Frequency Response with No Control');
xlabel('time (s)'); ylabel('?f(t)');
%legend(num2str(Hvec(0)), num2str(Hvec(1)), num2str(Hvec(2)), num2str(Hvec(3)), num2str(Hvec(4)), num2str(Hvec(5)));
legend(num2str(0.01), num2str(0.1), num2str(1), num2str(6), num2str(8), num2str(10));
hold off
%% No Control
for ii=1:length(Hvec)
    H = Hvec(ii)    % inertia constant
    
    %%%% Coefficients %%%%
    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));

    % Solve ODE
    [T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);

    figure(2)
    hold on

    if ii == 1
        plot(T1, F1, 'r:');

    elseif ii == 2
        plot(T1, F1, 'g--');

    elseif ii == 3
        plot(T1, F1, 'c-.');

    elseif ii == 4
        plot(T1, F1, 'b-');

    elseif ii == 5 
        plot(T1, F1, 'm:');

    else
        plot(T1, F1, 'k--');

    end
end
title('Frequency Response with No Control');
xlabel('time (s)'); ylabel('?f(t)');
%legend(num2str(Hvec(0)), num2str(Hvec(1)), num2str(Hvec(2)), num2str(Hvec(3)), num2str(Hvec(4)), num2str(Hvec(5)));
legend(num2str(0.01), num2str(0.1), num2str(1), num2str(6), num2str(8), num2str(10));
hold off
%% Constant Power
for ii=1:length(Hvec)
    H = Hvec(ii)    % inertia constant
    
    %%%% Coefficients %%%%
    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));

    [T2, F2] = ode45(@(t,f) constantPower(t, f, A, B, q), TSPAN, IC);
    
    figure(3)
    hold on

    if ii == 1
        plot(T2, F2, 'r:');

    elseif ii == 2
        plot(T2, F2, 'g--');

    elseif ii == 3
        plot(T2, F2, 'c-.');

    elseif ii == 4
        plot(T2, F2, 'b-');

    elseif ii == 5 
        plot(T2, F2, 'm:');

    else
        plot(T2, F2, 'k--');
    end
    
end
title('Frequency Response with Constant Power');
xlabel('time (s)'); ylabel('?f(t)');
legend(num2str(0.01), num2str(0.1), num2str(1), num2str(6), num2str(8), num2str(10));
hold off
%% Droop Control
for ii=1:length(Hvec)
    H = Hvec(ii)    % inertia constant
    
    %%%% Coefficients %%%%
    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));

    [T3, F3] = ode45(@(t,f) droopControl(t, f, A, B, q, R), TSPAN, IC);
    
    figure(4)
    hold on

    if ii == 1
        plot(T3, F3, 'r:');

    elseif ii == 2
        plot(T3, F3, 'g--');

    elseif ii == 3
        plot(T3, F3, 'c-.');

    elseif ii == 4
        plot(T3, F3, 'b-');

    elseif ii == 5 
        plot(T3, F3, 'm:');

    else
        plot(T3, F3, 'k--');
    end
end
title('Frequency Response with Droop Control');
xlabel('time (s)'); ylabel('?f(t)');
legend(num2str(0.01), num2str(0.1), num2str(1), num2str(6), num2str(8), num2str(10));
hold off
%% Virtual Inertia
Hvec = [0.01 0.1 1 6 8 10];

for ii=1:length(Hvec)
    H = Hvec(ii)    % inertia constant
    
    %%%% Coefficients %%%%
    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));

    [T4, F4] = ode45(@(t,f) virtualInertia(t, f, A, B, q, R, M), TSPAN, IC);
    
    figure(5)
    hold on

    if ii == 1
        plot(T4, F4, 'r:');

    elseif ii == 2
        plot(T4, F4, 'g--');

    elseif ii == 3
        plot(T4, F4, 'c-.');

    elseif ii == 4
        plot(T4, F4, 'b-');

    elseif ii == 5 
        plot(T4, F4, 'm:');

    else
        plot(T4, F4, 'k--');
    end
end
title('Frequency Response with Virtual Inertia');
xlabel('time (s)'); ylabel('?f(t)');
legend(num2str(0.01), num2str(0.1), num2str(1), num2str(6), num2str(8), num2str(10));
hold off

%% Comparing controllers with H=10
figure(6)
hold on
H = 10;

A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

[T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);
[T3, F3] = ode45(@(t,f) droopControl(t, f, A, B, q, R), TSPAN, IC);
[T4, F4] = ode45(@(t,f) virtualInertia(t, f, A, B, q, R, M), TSPAN, IC);

plot(T1,F1);
plot(T3,F3);
plot(T4,F4);
%ylim([-1, 1]);
legend('No Control', 'Droop Control', 'Virtual Inertia');

%% Testing Droop Control Parameters

H = 6;
R = 1.5;

A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

[T3, F3] = ode45(@(t,f) droopControl(t, f, A, B, q, R), TSPAN, IC);

figure
hold on
plot(T3,F3);

R = 15;
[T3, F3] = ode45(@(t,f) droopControl(t, f, A, B, q, R), TSPAN, IC);
plot(T3,F3);

R = 150;
[T3, F3] = ode45(@(t,f) droopControl(t, f, A, B, q, R), TSPAN, IC);
plot(T3,F3);

legend('R=1.5', 'R=15', 'R=150');


%% Testing Virtual Inertia Parameters

H = 6;

A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));


for R = [0.15 1.5 15 150 1500]
    
    figure
    hold on
    [T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);
    plot(T1,F1,'k');
    for M = [0.0015 0.015 0.15 1.5 15]

        [T4, F4] = ode45(@(t,f) virtualInertia(t, f, A, B, q, R, M), TSPAN, IC);
        plot(T4,F4);
        ylim([-0.025 0.005]);
        xlim([0 0.2]);
    end
    legend('No Control', 'M=0.0015', 'M=0.015', 'M=0.15', 'M=1.5', 'M=15');
    title(num2str(R));
end

%% 

H = 6;

A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));


for M = [0.0015 0.015 0.15 1.5 15]
    
    figure
    hold on
    [T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);
    plot(T1,F1,'k');
    for R = [0.15 1.5 15 150 1500]

        [T4, F4] = ode45(@(t,f) virtualInertia(t, f, A, B, q, R, M), TSPAN, IC);
        plot(T4,F4);
        ylim([-0.025 0.005]);
        xlim([0 0.2]);
    end
    legend('No Control', 'R=0.15', 'R=1.5', 'R=15', 'R=150', 'R=1500');
    title(num2str(M));
end

%%

H = 0;

A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

figure
hold on

[T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);
plot(T1,F1,'k');

for R = [0.15 15 1500]

    for M = [0.0015 0.15 15]

        [T4, F4] = ode45(@(t,f) virtualInertia(t, f, A, B, q, R, M), TSPAN, IC);
        plot(T4,F4);
        
    end
    
end

str0 = strcat('R=',num2str(0.15),' M=', num2str(0.0015));
str1 = strcat('R=',num2str(0.15),' M=', num2str(0.15));
str2 = strcat('R=',num2str(0.15),' M=', num2str(15));
str3 = strcat('R=',num2str(15),' M=', num2str(0.0015));
str4 = strcat('R=',num2str(15),' M=', num2str(0.15));
str5 = strcat('R=',num2str(15),' M=', num2str(15));
str6 = strcat('R=',num2str(1500),' M=', num2str(0.0015));
str7 = strcat('R=',num2str(1500),' M=', num2str(0.15));
str8 = strcat('R=',num2str(1500),' M=', num2str(15));

legend('No Control', str0, str1, str2, str3, str4, str5, str6, str7, str8);
title('Virtual Inertia');
ylim([-0.065 0.005]);
xlim([0 0.4]);

%% Droop Control

H = 6;

A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

figure
hold on

[T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);
plot(T1,F1,'k');

for R = [0.0015 0.015 0.15 15 1500]

    [T3, F3] = ode45(@(t,f) droopControl(t, f, A, B, q, R), TSPAN, IC);
    plot(T3,F3);
    
end

str0 = strcat('R=',num2str(0.0015));
str1 = strcat('R=',num2str(0.015));
str2 = strcat('R=',num2str(0.15));
str3 = strcat('R=',num2str(15));
str4 = strcat('R=',num2str(1500));

legend('No Control', str0, str1, str2, str3, str4);
title('Droop Control');
%ylim([-0.065 0.005]);
%xlim([0 0.4]);


%% Comparision with H = 6

H = 6;

TSPAN = 0:0.01:0.5;

A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

[T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);
[T3, F3] = ode45(@(t,f) droopControl(t, f, A, B, q, R), TSPAN, IC);
[T4, F4] = ode45(@(t,f) virtualInertia(t, f, A, B, q, R, M), TSPAN, IC);

figure
hold on
plot(T1,F1); plot(T3,F3); plot(T4,F4);
legend('No control', 'Droop Control', 'Virtual Inertia');
title('H = 6');


%% No Control
clear all;

format long

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 15;         % droop coefficient
M = 0.15;       % virtual inertia
% Values from: https://mallada.ece.jhu.edu/pubs/2016-M-CDC.pdf

H = 6;


A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

N = B;
D = [1 -A];

sys = tf(N, D);

[y,t] = step(sys);
figure
plot(t, y);
xlim([0 0.07]); ylim([0 0.021]);
title('No Control Step Response H = 6');

noControlSSE = y(length(y))

S1 = stepinfo(sys)

%% Droop Control
clear all;

format long

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 15;         % droop coefficient
M = 0.15;       % virtual inertia
% Values from: https://mallada.ece.jhu.edu/pubs/2016-M-CDC.pdf
figure
hold on

H = 6;

A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

for R = [0.02 0.021 0.025 0.15]
    R
    N = B;
    D = [1 -1*(A + (B/R))];
    sys = tf(N, D);

    [y, t] = step(sys);
     
    plot(t, y);
    %xlim([0 0.07]); ylim([0 0.021]);
    title('Droop Control Step Response H = 6');

    droopControlSSE = y(length(y))

    S2 = stepinfo(sys)
end

%% Virtual Inertia
clear all;

format long

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 15;         % droop coefficient
M = 0.15;       % virtual inertia
% Values from: https://mallada.ece.jhu.edu/pubs/2016-M-CDC.pdf


%%%% Functions %%%%
TSPAN = [0 0.5];
IC = 0;         % Initial Condition: delta_f(t=0) = 0;

H = 6;

A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

N = B;
D = [((B*M)+1) -(A+(B/R))];

sys = tf(N, D);

[y,t] = step(sys);
figure
plot(t, y);
xlim([0 0.07]); ylim([0 0.021]);
title('Virtual Inertia Step Response H = 6');

virtualInertiaSSE = y(length(y))

S3 = stepinfo(sys)

%% Droop Control Rise Time Heat Map

clear all;
H = 6;
f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 15;         % droop coefficient
M = 0.15;       % virtual inertia
ii = 0; jj = 0;
Hvec = 0.1:0.1:10;
Rvec = 0.1:0.1:10;

matrix = zeros(100,100);

for ii = 1:length(Rvec)  % y axis rows
    for jj = 1:length(Hvec)  % x axis columns
        
        R = Rvec(ii);
        H = Hvec(jj);
        
        A = -1*(f_0/(2*H*S_B*D));
        B = (f_0/(2*H*S_B));

        Num = B;
        Denom = [1 -1*(A + (B/R))];
        sys = tf(Num, Denom);
        S = stepinfo(sys);

        rise = S.RiseTime;
        
        matrix(ii,jj) = rise;
        
    end
end

