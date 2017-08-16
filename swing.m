% swing.m
% Megan Swanson
% SUPERB Project 2017
%
%       This script uses the swing equation to model the frequency response
%       of a power system after a loss of generation.
%
%       * More research needs to go into what would be optimal values of R and M
%       in terms of feasibility. My "optimal" values are R = 0.15 and M = 15 which
%       I choose simply because I didn't want to deviate too far from the values
%       used in the Mallada paper (https://mallada.ece.jhu.edu/pubs/2016-M-CDC.pdf).

clear all; close all; clc;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% SECTION 1: Plotting Frequency Response of Controllers %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 1.a: Plot p.u. disturbance function
clear all;

syms x
p = piecewise(0.05<x<0.1, -1, 0);

figure
hold on
fplot(p);
title('Disturbance');
xlabel('Time(s)'); ylabel('∆P(t) p.u.');
xlim([0.03 0.16]); ylim([-0.021 0.001]);


%% 1.b: Plot FR with No Control H={0.1, 1, 5, 10}
clear all;

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 15;         % droop coefficient
M = 0.15;       % virtual inertia
% Values from: https://mallada.ece.jhu.edu/pubs/2016-M-CDC.pdf

TSPAN = [0 0.5];
IC = 0;         % Initial Condition: ∆f(t=0) = 0;
Hvec = [0.1 1 5 10];

figure
hold on

for ii=1:length(Hvec)
    H = Hvec(ii);    % inertia constant
    
    % Calculate coefficients for ODE
    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));

    % Solve ODE
    [T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);

    plot(T1, F1);
end
title('Frequency Response with No Control');
xlabel('Time(s)'); ylabel('∆f(t)');
xlim([0.03 0.16]); ylim([-0.021 0.001]);
legend('H=0.1', 'H=1', 'H=5', 'H=10');

hold off


%% 1.c: Plot Droop Control H={0.1, 1, 5, 10}
clear all;

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 15;         % droop coefficient
M = 0.15;       % virtual inertia
% Values from: https://mallada.ece.jhu.edu/pubs/2016-M-CDC.pdf

TSPAN = [0 0.5];
IC = 0;         % Initial Condition: ∆f(t=0) = 0;
Hvec = [0.1 1 5 10];

figure
hold on

for ii=1:length(Hvec)
    H = Hvec(ii);    % inertia constant
    
    % Calculate coefficients for ODE
    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));

    % Solve ODE
    [T3, F3] = ode45(@(t,f) droopControl(t, f, A, B, q, R), TSPAN, IC);
    
    plot(T3, F3);
end
title('Frequency Response with Droop Control');
xlabel('Time(s)'); ylabel('∆f(t)');
xlim([0.03 0.16]); ylim([-0.021 0.001]);
legend('H=0.1', 'H=1', 'H=5', 'H=10');

hold off


%% 1.d: Plot Virtual Inertia H={0.1, 1, 5, 10}
clear all;

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 15;         % droop coefficient
M = 0.15;       % virtual inertia
% Values from: https://mallada.ece.jhu.edu/pubs/2016-M-CDC.pdf

TSPAN = [0 0.5];
IC = 0;         % Initial Condition: ∆f(t=0) = 0;
Hvec = [0.1 1 5 10];

figure
hold on

for ii=1:length(Hvec)
    H = Hvec(ii);    % inertia constant
    
    %Calculate coefficients for ODE
    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));

    % Solve ODE
    [T4, F4] = ode45(@(t,f) virtualInertia(t, f, A, B, q, R, M), TSPAN, IC);
    
    plot(T4, F4);
end
title('Frequency Response with Virtual Inertia Control');
xlabel('Time(s)'); ylabel('∆f(t)');
xlim([0.03 0.16]); ylim([-0.021 0.001]);
legend('H=0.1', 'H=1', 'H=5', 'H=10');
hold off
%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% SECTION 2: Comparing Controllers %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 2.a: Comparing controllers with H = 1
clear all;

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 0.15;       % droop coefficient (optimal* value)
M = 15;         % virtual inertia (optimal* value)

TSPAN = [0 0.5];
IC = 0;         % Initial Condition: ∆f(t=0) = 0;

figure
hold on
H = 1;

% Calculate coefficients
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

legend('None', 'DC', 'VI', 'DC & VI');
title('Frequency Response H = 1');
xlabel('Time(s)'); ylabel('∆f(t)');
xlim([0.03 0.16]); ylim([-0.021 0.001]);

% Calculating Frequency Nadir
[Nmin, indx] = min(F1);
time = T1(indx);
Dmin = min(F3)  % Droop Control Freq. Nadir
Vmin = min(F4)  % Virtual Inertia Freq. Nadir
Bmin = min(F5)  % DC & VI (Both) Freq. Nadir


%% 2.b: Testing Droop Control Parameter R = [0.025 0.05 0.25 0.5 2.5], H = 1
clear all;

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 0.15;       % droop coefficient (optimal* value)
M = 15;         % virtual inertia (optimal* value)

TSPAN = [0 0.5];
IC = 0;         % Initial Condition: ∆f(t=0) = 0;

figure
hold on

H = 1;          % Inertia Constant

% Calculate coefficients for ODE
A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

figure
hold on

% Solve ODE with No Control
[T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);

plot(T1,F1,'k'); % Plot No Control in black for comparison

Nmin = min(F1); % Frequency Nadir for No Control

for R = [0.025 0.05 0.25 0.5 2.5]
    % Solve ODE with Droop Control
    [T3, F3] = ode45(@(t,f) droopControl(t, f, A, B, q, R), TSPAN, IC);
    plot(T3,F3);
    
    Dmin = min(F3); % Frequncy Nadir for Droop Control
    diff = Dmin-Nmin % How much the Droop Control reduced the Frequency Nadir
end

legend('No Control', 'R=0.025', 'R=0.05', 'R=0.25', 'R=0.5', 'R=2.5');
title('Droop Control H = 1')
xlabel('Time(s)'); ylabel('∆f(t)');
xlim([0.03 0.16]); ylim([-0.021 0.001]);
hold off


%% 2.c: Testing Virtual Inertia Parameter M = [0.1 0.5 1 5 10], H = 1
clear all;

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 0.15;       % droop coefficient (optimal* value)
M = 15;         % virtual inertia (optimal* value)

TSPAN = [0 0.5];
IC = 0;         % Initial Condition: ∆f(t=0) = 0;

H = 1;

% Calculate coefficients for ODE
A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

figure
hold on

% Solve ODE with No Control
[T1, F1] = ode45(@(t,f) mySwing(t, f, A, B), TSPAN, IC);

plot(T1,F1,'k'); % Plot No Control in black for comparison

Nmin = min(F1); % Frequency Nadir for No Control

for M = [0.1 0.5 1 5 10]
    % Solve ODE with Virtual Inertia
    [T4, F4] = ode45(@(t,f) virtualInertia(t, f, A, B, q, R, M), TSPAN, IC);
    plot(T4,F4);
    
    Vmin = min(F3); % Frequncy Nadir for Virtual Inertia
    diff = Vmin-Nmin % How much the Virtual Vnertia reduced the Frequency Nadir
end
legend('No Control', 'M=0.1', 'M=0.5', 'M=1', 'M=5', 'M=10');
title('Virtual Inertia H=1');
xlabel('Time(s)'); ylabel('∆f(t)');
xlim([0.03 0.16]); ylim([-0.021 0.001]);
hold off


%% 2.d: Controller Comparision with Optimal* parameters R and M, H = [0.1 1 5 10]
clear all;

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 0.15;       % droop coefficient (optimal* value)
M = 15;         % virtual inertia (optimal* value)

TSPAN = [0 0.5];
IC = 0;         % Initial Condition: ∆f(t=0) = 0;

ii = 1;

for H = [0.1 1 5 10]

    A = -1*(f_0/(2*H*S_B*D));
    B = (f_0/(2*H*S_B));
    
    figure
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
    xlabel('Time(s)'); ylabel('∆f(t)');
    ii = ii + 1;
end
hold off
%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% SECTION 3: Plotting Step Response of Controllers %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 3.a: Plot No Control Step Resonse H = 1
clear all;

format long

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 0.15;       % droop coefficient (optimal* value)
M = 15;         % virtual inertia (optimal* value)

H = 1;          % Inertia Constant

% Calculate coefficients for ODE
A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

Num = B; % Numerator of transfer function
Denom = [1 -A]; % Denominator of transfer function

sys = tf(Num, Denom); % Create transfer function

[y,t] = step(sys); % Calculate step response

figure

plot(t, y); % Plot step response
%xlim([0 0.07]); ylim([0 0.021]);
title('No Control Step Response H = 1');

noControlSSE = y(length(y)) % No Control Steady State Error

S = stepinfo(sys); % Step Response object

NCRiseTime = S.RiseTime; % Get rise time of no control step response


%% 3.b: Plot Droop Control Step Response R = [0.025 0.05 0.25 0.5 2.5], H = 1
clear all;

format long

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 0.15;       % droop coefficient (optimal* value)
M = 15;         % virtual inertia (optimal* value)

H = 1;          % Inertia Constant

% Calculate coefficients for ODE
A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

figure
hold on

for R = [0.025 0.05 0.25 0.5 2.5]
    
    R
    
    Num = B; % Numerator for transfer function
    Denom = [1 -1*(A + (B/R))]; % Denominator for transfer function
    
    sys = tf(Num, Denom); % Create transfer function

    [y, t] = step(sys); % Calculate step response
     
    plot(t, y); % Plot step response
    droopControlSSE = y(length(y)) % Droop Control Steady State Error

    S = stepinfo(sys); % Step response object
    
    DCRiseTime = S.RiseTime % Get rise time of droop control step response
end
%xlim([0 0.07]); ylim([0 0.021]);
title('Droop Control Step Response H = 1');
legend('R=0.025', 'R=0.05', 'R=0.25', 'R=0.5', 'R=2.5');
hold off


%% 3.c: Plot Virtual Inertia Step Response M = [0.1 0.5 1 5 10], H = 1
clear all;

format long

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 0.15;       % droop coefficient (optimal* value)
M = 15;         % virtual inertia (optimal* value)

H = 1;          % Inertia Constant

% Calculate coefficients for ODE
A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

figure
hold on

for M = [0.1 0.5 1 5 10]

    M
    
    Num = B; % Numerator for transfer function
    Denom = [((B*M)+1) -A]; % Denominator for transfer function

    sys = tf(Num, Denom); % Create transfer function

    [y, t] = step(sys); % Calculate step response
     
    plot(t, y); % Plot step response
    
    virtualInertiaSSE = y(length(y)) % Virtual Inertia Steady State Error

    S = stepinfo(sys); % Step response object
    
    VIRiseTime = S.RiseTime % Get rise time of virtual inertia step response
    
end
%xlim([0 0.07]); ylim([0 0.021]);
title('Virtual Inertia Step Response H = 1');
legend('No Control', 'M=0.1', 'M=0.5', 'M=1', 'M=5', 'M=10');
hold off


%% 3.d: Plot Both DC&VI Step Response with Optimal* R and M
clear all;

format long

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 0.15;       % droop coefficient (optimal* value)
M = 15;         % virtual inertia (optimal* value)

H = 1;          % Inertia Constant

% Calculate coefficients for ODE
A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B));

figure

Num = B; % Numerator for transfer function
Denom = [((B*M)+1) -(A+(B/R))]; % Denominator for transfer function

sys = tf(Num, Denom); % Create transfer function

[y,t] = step(sys); % Calculate step response

plot(t, y); % Plot step response

DCVISSE = y(length(y)) % DC&VI Steady State Error

S = stepinfo(sys); % Step response object

DCVIRiseTime = S.RiseTime % Get rise time for DC&VI step response

%xlim([0 0.07]); ylim([0 0.021]);
title('DC & VI Step Response H = 1');

%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% SECTION 4: Heatmaps for Controllers %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 4.a: Droop Control Heatmap Matrix
clear all;

f_0 = 60;       % nominal frequency
S_B = 1.8;      % p.u. base power
D = 0.02;       % damping coefficient

q = 0;          % power generation set point
R = 0.15;       % droop coefficient (optimal* value)
M = 15;         % virtual inertia (optimal* value)

TSPAN = [0 0.5];
IC = 0;         % Initial Condition: ∆f(t=0) = 0;

Hvec = 0.1:1:10; % Vector for inertia constant H
Rvec = 0.025:0.025:0.25; % Vector for droop coefficient R


for jj = 1:length(Hvec)  % x axis columns    
    for ii = 1:length(Rvec)  % y axis rows
        
        R = Rvec(ii);
        H = Hvec(jj);
        
        % Calculate coefficients for ODE
        A = -1*(f_0/(2*H*S_B*D));
        B = (f_0/(2*H*S_B));

        Num = B; % Numerator for transfer function
        Denom = [1 -1*(A + (B/R))]; % Denominator for transfer function
        sys = tf(Num, Denom); % Create transfer function
        
        % Calculate Frequency Nadir Matrix
        [T3, F3] = ode45(@(t,f) droopControl(t, f, A, B, q, R), TSPAN, IC);
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

