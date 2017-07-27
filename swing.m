% swing.m
% Megan Swanson
% SUPERB Project 2017
%
%       This script uses the swing equation to model the frequency response
%       of a power system after a loss of generation.
%
% http://matlab.cheme.cmu.edu/2011/08/09/phase-portraits-of-a-system-of-odes/

clear all; close all; clc;

%% Inputs
Hvec = [0.1 1 6 8 10];

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

%% Plot p.u. disturbance function

syms x
p = piecewise(0.05<x<0.1, -1, 0);

figure
hold on
fplot(p);
title('Disturbance');
xlabel('Time(s)'); ylabel('?P(t) p.u.');
xlim([0.03, 0.16])
ylim([-1.1, 0.1])

%% Plot with No Control varying H
for ii=1:length(Hvec)
    H = Hvec(ii)    % inertia constant
    
    %%%% Coefficients %%%%
    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));

    % Solve ODE
    [T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);

    figure(1)
    hold on
    subplot(4,1,2)
    if ii == 1
        plot(T1, F1);

    elseif ii == 2
        plot(T1, F1);

    elseif ii == 3
        plot(T1, F1);

    elseif ii == 4
        plot(T1, F1);

    elseif ii == 5 
        plot(T1, F1);

    else
        plot(T1, F1);

    end
    xlim([0, 0.15])
end
title('Frequency Response with No Control');
xlabel('Time(s)'); ylabel('?f(t)');

str1 = strcat('H=',num2str(0.1));
str2 = strcat('H=',num2str(1));
str3 = strcat('H=',num2str(6));
str4 = strcat('H=',num2str(8));
str5 = strcat('H=',num2str(10));

legend(str1, str2, str3, str4, str5);
hold off

%% Plot Constant Power varying H
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
    xlim([0, 0.15])
    
end
title('Frequency Response with Constant Power');
xlabel('time (s)'); ylabel('?f(t)');
legend(num2str(0.01), num2str(0.1), num2str(1), num2str(6), num2str(8), num2str(10));
hold off

%% Plot Droop Control varying H
for ii=1:length(Hvec)
    H = Hvec(ii)    % inertia constant
    
    %%%% Coefficients %%%%
    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));

    [T3, F3] = ode45(@(t,f) droopControl(t, f, A, B, q, R), TSPAN, IC);
    
    figure(1)
    hold on
    subplot(4,1,3)

    if ii == 1
        plot(T3, F3);

    elseif ii == 2
        plot(T3, F3);

    elseif ii == 3
        plot(T3, F3);

    elseif ii == 4
        plot(T3, F3);

    elseif ii == 5 
        plot(T3, F3);

    else
        plot(T3, F3);
    end
    xlim([0, 0.15])
end
title('Frequency Response with Droop Control');
xlabel('Time(s)'); ylabel('?f(t)');

str1 = strcat('H=',num2str(0.1));
str2 = strcat('H=',num2str(1));
str3 = strcat('H=',num2str(6));
str4 = strcat('H=',num2str(8));
str5 = strcat('H=',num2str(10));

legend(str1, str2, str3, str4, str5);
hold off

%% Plot Virtual Inertia varying H

for ii=1:length(Hvec)
    H = Hvec(ii)    % inertia constant
    
    %%%% Coefficients %%%%
    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));

    [T4, F4] = ode45(@(t,f) virtualInertia(t, f, A, B, q, R, M), TSPAN, IC);
    
    figure(1)
    hold on
    subplot(4,1,4)

    if ii == 1
        plot(T4, F4);

    elseif ii == 2
        plot(T4, F4);

    elseif ii == 3
        plot(T4, F4);

    elseif ii == 4
        plot(T4, F4);

    elseif ii == 5 
        plot(T4, F4);
        
    else
        plot(T4, F4);
    end
    xlim([0, 0.15])
end
title('Frequency Response with Virtual Inertia Control');
xlabel('Time(s)'); ylabel('?f(t)');

str1 = strcat('H=',num2str(0.1));
str2 = strcat('H=',num2str(1));
str3 = strcat('H=',num2str(6));
str4 = strcat('H=',num2str(8));
str5 = strcat('H=',num2str(10));

legend(str1, str2, str3, str4, str5);

hold off
%%





%% Comparing controllers with H=1
clear all;

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 0.15;         % droop coefficient
M = 15;       % virtual inertia

TSPAN = [0 0.5];
IC = 0;

figure
hold on
H = 10;

A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

[T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);
[T3, F3] = ode45(@(t,f) droopControl(t, f, A, B, q, R), TSPAN, IC);
[T4, F4] = ode45(@(t,f) virtualInertia(t, f, A, B, q, R, M), TSPAN, IC);
[T5, F5] = ode45(@(t,f) both(t, f, A, B, q, R, M), TSPAN, IC);

plot(T1,F1);
plot(T3,F3);
plot(T4,F4);
plot(T5,F5);

xlim([0.03 0.16]); ylim([-0.021 0.001]);
legend('None', 'DC', 'VI', 'DC & VI');
title('Frequency Response H = 1');
xlabel('Time(s)'); ylabel('?f(t)');

[Nmin, indx] = min(F1);
time = T1(indx)
Dmin = min(F3);
Vmin = min(F4);
Bmin = min(F5);


%% Testing Virtual Inertia Parameters varying M
clear all;

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 15;         % droop coefficient
M = 0.15;       % virtual inertia

TSPAN = [0 0.5];
IC = 0;

H = 1;

A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

figure
hold on
[T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);
plot(T1,F1,'k');
for M = [0.15 0.75 1.5 7.5 15]

    [T4, F4] = ode45(@(t,f) virtualInertia(t, f, A, B, q, R, M), TSPAN, IC);
    plot(T4,F4);
    
end
legend('No Control', 'M=0.15', 'M=0.75', 'M=1.5', 'M=7.5', 'M=15');
title('Virtual Inertia H=6');
xlim([0.03 0.16]); ylim([-0.021 0.001]);

hold off

%% Plot Droop Control varying R H = 6
clear all;

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 15;         % droop coefficient
M = 0.15;       % virtual inertia

TSPAN = [0 0.5];
IC = 0;

figure
hold on

H = 1;

A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

figure
hold on

[T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);
plot(T1,F1,'k');
    Nmin = min(F1);

for R = [0.01 0.5 1 5 10]

    [T3, F3] = ode45(@(t,f) droopControl(t, f, A, B, q, R), TSPAN, IC);
    plot(T3,F3);
    Dmin = min(F3);
    diff = Dmin-Nmin
end
str0 = strcat('R=',num2str(0.015));
str1 = strcat('R=',num2str(0.15));
str2 = strcat('R=',num2str(1.5));
str3 = strcat('R=',num2str(15));

legend('No Control', str0, str1, str2, str3);
title('Droop Control H = 6')
xlim([0.03 0.16]); ylim([-0.021 0.001]);
hold off



%% Comparision varying H
clear all;

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 0.1;         % droop coefficient
M = 10;       % virtual inertia
figure
TSPAN = [0 0.5];
IC = 0;

ii = 1;

for H = [0.1 1 5 10]

    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));
    subplot(4, 1, ii);
    hold on
    [T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);
    [T3, F3] = ode45(@(t,f) droopControl(t, f, A, B, q, R), TSPAN, IC);
    [T4, F4] = ode45(@(t,f) virtualInertia(t, f, A, B, q, R, M), TSPAN, IC);
    [T5, F5] = ode45(@(t,f) both(t, f, A, B, q, R, M), TSPAN, IC);

    plot(T1,F1); plot(T3,F3); plot(T4,F4);plot(T5, F5);
    xlim([0.03 0.16]); ylim([-0.021 0.001]);
    legend('None', 'DC', 'VI', 'DC & VI');
    str = strcat('H =  ', num2str(H));
    title(str);
    xlabel('Time(s)'); ylabel('?f(t)');
    ii = ii + 1;
end
hold off
%%





%% Plot No Control Step Resonse H = 6
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

%% Plot Droop Control Step Response H = 6 varying R
clear all;

format long

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 15;         % droop coefficient
M = 0.15;       % virtual inertia

figure
hold on

H = 6;

A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

for R = [0.0000000000000001 0.15 0.75 1.5 7.5 15]
    R
    N = B;
    D = [1 -1*(A + (B/R))];
    sys = tf(N, D);

    [y, t] = step(sys);
     
    plot(t, y);

    title('Droop Control Step Response H = 6');

    droopControlSSE = y(length(y))

    S2 = stepinfo(sys)
end
str0 = strcat('R=',num2str(0));
str1 = strcat('R=',num2str(0.15));
str2 = strcat('R=',num2str(0.75));
str3 = strcat('R=',num2str(1.5));
str4 = strcat('R=',num2str(7.5));
str5 = strcat('R=',num2str(15));


legend(str0, str1, str2, str3, str4, str5);
hold off

%% Plot Virtual Inertia Step Response 
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

H = 1;

A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

figure
hold on

for M = [0 0.15 0.75 1.5 7.5 15]

    N = B;
    D = [((B*M)+1) -A];

    sys = tf(N, D);

    [y,t] = step(sys);
    
    plot(t, y);
    
    virtualInertiaSSE = y(length(y))

    S3 = stepinfo(sys)
end
%xlim([0 0.07]); ylim([0 0.021]);

title('Virtual Inertia Step Response H = 6');
str0 = strcat('M=',num2str(0.15));
str1 = strcat('M=',num2str(0.75));
str2 = strcat('M=',num2str(1.5));
str3 = strcat('M=',num2str(7.5));
str4 = strcat('M=',num2str(15));

legend(str0, str1, str2, str3, str4);
hold off

%% Plot Both Step Response 
clear all;

format long

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 0.15;         % droop coefficient
M = 15;       % virtual inertia
% Values from: https://mallada.ece.jhu.edu/pubs/2016-M-CDC.pdf


%%%% Functions %%%%
TSPAN = [0 0.5];
IC = 0;         % Initial Condition: delta_f(t=0) = 0;

H = 1;

A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

figure
hold on


Num = B;
Denom = [((B*M)+1) -(A+(B/R))];

sys = tf(Num, Denom);

[y,t] = step(sys);

plot(t, y);

bothSSE = y(length(y))

S4 = stepinfo(sys)

%xlim([0 0.07]); ylim([0 0.021]);

title('Virtual Inertia Step Response H = 6');
str0 = strcat('M=',num2str(0.15));
str1 = strcat('M=',num2str(0.75));
str2 = strcat('M=',num2str(1.5));
str3 = strcat('M=',num2str(7.5));
str4 = strcat('M=',num2str(15));

legend(str0, str1, str2, str3, str4);
hold off


%%






%% Droop Control Heatmap Matrix

clear all;
H = 6;
f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 15;         % droop coefficient
M = 0.15;       % virtual inertia

TSPAN = [0 0.5];
IC = 0;

Hvec = 0.1:1:10;
Rvec = 0.025:0.025:0.25;


for jj = 1:length(Hvec)  % x axis columns    
    for ii = 1:length(Rvec)  % y axis rows
        
        R = Rvec(ii);
        H = Hvec(jj);
        
        A = -1*(f_0/(2*H*S_B*D));
        B = (f_0/(2*H*S_B));

        Num = B;
        Denom = [1 -1*(A + (B/R))];
        sys = tf(Num, Denom);
        
        % Calculate Steady State Error
        [t,y] = step(sys);
        DsseMatrix(ii,jj) = y(length(y));
        
        % Calculate Frequency Nadir
        %[T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);
        [T3, F3] = ode45(@(t,f) droopControl(t, f, A, B, q, R), TSPAN, IC);
        %Nmin = min(F1);
        Dmin = min(F3);
        DnadirMatrix(ii,jj) = Dmin;
        
        % Calculate Risetime
        S = stepinfo(sys);
        rise = S.RiseTime;
        DriseMatrix(ii,jj) = rise;
        
    end
end

%% Droop Control Risetime Heatmap

hDR = heatmap(DriseMatrix);
%hD.ColorLimits = [0.0003 0.03];
hDR.Title = 'Droop Control Risetime, H vs. R';
hDR.XLabel = 'Inertia H = [0.1 10]';
hDR.YLabel = 'Droop Coefficient R = [0.05 1]';

%% Droop Control Nadir Heatmap

hDN = heatmap(DnadirMatrix);
%hD.ColorLimits = [0.0003 0.03];
hDN.Title = 'Droop Control Nadir, H vs. R';
hDN.XLabel = 'Inertia H = [0.1 10]';
hDN.YLabel = 'Droop Coefficient R = [0.05 1]';


%% Virtual Inertia Rise Time Matrix

%clear all;
H = 6;
f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 15;         % droop coefficient
M = 0.15;       % virtual inertia

TSPAN = [0 0.5];
IC = 0;

ii = 0; jj = 0;
Hvec = 0.1:1:10;
Mvec = 0.1:1:10;


for jj = 1:length(Hvec)  % x axis columns    
    for ii = 1:length(Mvec)  % y axis rows
        
        M = Mvec(ii);
        H = Hvec(jj);
        
        A = -1*(f_0/(2*H*S_B*D));
        B = (f_0/(2*H*S_B));

        Num = B;
        Denom = [((B*M)+1) -(A+(B/R))];
        sys = tf(Num, Denom);
        
        % Calculate Steady State Error
        [t,y] = step(sys);
        VsseMatrix(ii,jj) = y(length(y));
        
        % Calculate Frequency Nadir
        [T4, F4] = ode45(@(t,f) virtualInertia(t, f, A, B, q, R, M), TSPAN, IC);
        Vmin = min(F4);
        VnadirMatrix(ii,jj) = Vmin;

        % Calculate Risetime
        S = stepinfo(sys);
        rise = S.RiseTime;
        VriseMatrix(ii,jj) = rise;
        
    end
end

%% Virtual Inertia Risetime Heatmap

hVR = heatmap(VriseMatrix);
hVR.Title = 'Virtual Inertia Risetime, H vs. M';
hVR.XLabel = 'Inertia H = [0.1 10]';
hVR.YLabel = 'Virtual Inertia M = [0.15 15]';

%% Virtual Inertia SSE Heatmap

hVN = heatmap(VnadirMatrix);
hVN.Title = 'Virtual Inertia Frequency Nadir, H vs. M';
hVN.XLabel = 'Inertia H = [0.1 10]';
hVN.YLabel = 'Virtual Inertia M = [0.15 15]';


%%
figure
% Droop Control Risetime Heatmap
%subplot(2,2,1);
hDR = heatmap(DriseMatrix);
hDR.ColorLimits = [0 0.4];
hDR.Title = 'Droop Control Risetime';
hDR.XLabel = 'H = [0.1 10]';
hDR.YLabel = 'R = [0.025 0.25]';

% Droop Control Nadir Heatmap
figure
%subplot(2,2,2);
hDN = heatmap(DnadirMatrix);
hDN.ColorLimits = [-0.02 -0.01];
hDN.Title = 'Droop Control Frequency Nadir';
hDN.XLabel = 'H = [0.1 10]';
hDN.YLabel = 'R = [0.025 0.25]';

% Virtual Inertia Risetime Heatmap
figure
%subplot(2,2,3);
hVR = heatmap(VriseMatrix);
hVR.ColorLimits = [0 0.4];
hVR.Title = 'Virtual Inertia Risetime';
hVR.XLabel = 'H = [0.1 10]';
hVR.YLabel = 'M = [0.1 10]';

% Virtual Inertia SSE Heatmap
figure
%subplot(2,2,4);
hVN = heatmap(VnadirMatrix);
hVN.ColorLimits = [-0.02 -0.01];
hVN.Title = 'Virtual Inertia Frequency Nadir';
hVN.XLabel = 'H = [0.1 10]';
hVN.YLabel = 'M = [0.1 10]';

