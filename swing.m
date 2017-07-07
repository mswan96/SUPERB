% swing.m
% Megan Swanson
% SUPERB Project 2017
%
%       This script uses the swing equation to model the frequency response
%       of a power system after a loss of generation.
%
% http://matlab.cheme.cmu.edu/2011/08/09/phase-portraits-of-a-system-of-odes/

clear all; close all;

%%%% Parameters %%%%

f_0 = 60;
H = 6;
H_1 = 6;
H_2 = 6;
S_B = 115000000;
k = 1.5;
D = (1/k);
%P_m = ;
%P_load = ;
P_delta = 3000000;
P_delta1 = 1000000;
P_delta2 = 0;
P_loss = 0;
V_1 = 1;
V_2 = 1;

M_1 = (2*H_1*S_B)/(2*pi*f_0);
M_2 = (2*H_2*S_B)/(2*pi*f_0);

B_1 = 0.0000000001*10000000000;
B_2 = 0.0000000001*100000000000;
%B_3 = f_0/(2*H_3*S_B);

A = -1*(f_0/(2*H*S_B*D));
B = (f_0/(2*H*S_B))*(P_delta - P_loss);

A1 = P_delta1/M_1
B1 = k/M_1
C1 = (V_1*V_2*B_2)/M_1
%D1 = (V_1*V_3*B_3)/M_1

A2 = P_delta2/M_2
B2 = k/M_2
C2 = (V_2*V_1*B_1)/M_2
%D2 = (V_2*V_3*B_3)/M_2;

%%%% Functions %%%%

% #1: Aggregated Swing Equation
% f = @(t,X) [X(2); A*X(1)+B];

% #2: function from http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=1086115
% f = @(t,X) [X(2); 0.234 - 0.7143*X(2) - 0.0633*sin(X(1) + 0.0405) - 0.582*sin(X(1) + 0.4103)];
% #2a-c: Replicated varied inertia and damping results from Andersson paper using #2
%   #2a: M = 2*M0; k = k0
% fa = @(t,X) [X(2); 0.5*(0.234 - 0.7143*X(2) - 0.0633*sin(X(1) + 0.0405) - 0.582*sin(X(1) + 0.4103))];
%   #2b: M = 0.5*M0; k = 2*k0
% fb = @(t,X) [X(2); 2*(0.234 - 2*(0.7143*X(2)) - 0.0633*sin(X(1) + 0.0405) - 0.582*sin(X(1) + 0.4103))];
%   #2c: M = M0; k = 2*k0
% f = @(t,X) [X(2); 0.234 - 2*(0.7143*X(2)) - 0.0633*sin(X(1) + 0.0405) - 0.582*sin(X(1) + 0.4103)];

% #3: My attempt to parameterize and replicate the results of #2
% f = @(t,X) [X(2); A1 - B1*X(2) - C1*sin(X(1) + .0405) - D1*sin(X(1) + 0.4103)];

% #4: Fully parameterized two-area model
% f = @(t,Y) [Y(3); Y(4); A1 + B1*Y(3) + C1*sin(Y(1) - Y(2)); A2 + B2*Y(4) + C2*sin(Y(2) - Y(1))];
% NOTE: This verison of the two area model is difficult to solve with
% initial conditions because you need both angle and angular frequency
% values.

% #5: Fully parameterized two-area model using X(1) = d1-d2 and X(2) = w1-w2 or X(1)prime
 f = @(t,X) [X(2); A1 - A2 - (B1 - B2)*X(1) - C1*sin(X(1)) + C2*sin(-X(1))];
% NOTE: only works with assumption that k1 = k2

% To generate the phase portrait, we need to compute the derivatives $y_1'$ and $y_2'$ 
% at $t=0$ on a grid over the range of values for $y_1$ and $y_2$ we are interested in. 
% We will plot the derivatives as a vector at each (y1, y2) which will show us the initial 
% direction from each point. We will examine the solutions over the range -2 < y1 < 8, and 
% -2 < y2 < 2 for y2, and create a grid of 20x20 points.

y1 = linspace(-100,100,50);
y2 = linspace(-100,100,50);

[x,y] = meshgrid(y1,y2);
size(x);
size(y);

% computing the vector field

u = zeros(size(x));
v = zeros(size(x));

% we can use a single loop over each element to compute the derivatives at
% each point (y1, y2)
t=0; % we want the derivatives at each point at t=0, i.e. the starting time

for i = 1:numel(x)
    Yprime = f(t,[x(i);y(i);x(i);y(i)]);
    u(i) = Yprime(1);
    v(i) = Yprime(2);
end

quiver(x,y,u,v,'r'); figure(gcf)
xlabel('x_1')
ylabel('x_2')
axis tight equal;

%% PLOT SOLUTIONS

hold on
for y10 = -100:10:100
for y20 = -100:10:100
    
    % For functions #1, 2, 3, 5
    [ts,ys] = ode45(f,[0,500],[y10;y20]);
    plot(ys(:,1),ys(:,2))
    grid on
    ylim([-100, 100])
    xlim([-100, 100])
    
    % For function #4
    %[ts1,ys1] = ode45(f1,[0,500],[y10;y20;0;0]); 
    %plot(ys1(:,1)-ys1(:,3),ys1(:,2)-ys1(:,4))
    %[ts2,ys2] = ode45(f1,[0,500],[y10;y20;y10;y20]); 
    %plot(ys2(:,1)-ys2(:,3),ys2(:,2)-ys2(:,4))

    
    %[ts,ys] = ode45(f, [0, 500], [0;0;0;0]);
   
    %daspect([1 0.5 1]);
    %plot(ys(1,1),ys(1,2),'bo') % starting point
    %plot(ys(end,1),ys(end,2),'ks') % ending point
end
end
hold off
