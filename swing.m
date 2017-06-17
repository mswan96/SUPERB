% hw 3
% prob 2
% http://matlab.cheme.cmu.edu/2011/08/09/phase-portraits-of-a-system-of-odes/

clear all; close all; clc

%%

f_0 = 50;
H_1 = 6;
H_2 = 6;
S_B = 115000;
k = 1.5;
D = (1/k);
%P_m = ;
%P_load = ;
P_delta = 3000;
P_loss = 0;
V_1 = 1;
V_2 = 1;
V_3 = 3;

M_1 = (2*H_1*S_B)/(2*pi*f_0);
M_2 = (2*H_2*S_B)/(2*pi*f_0);

B_1 = f_0/(2*H_1*S_B);
B_2 = f_0/(2*H_2*S_B);
B_3 = 0;

%A = -(f_0/(2*H*S_B*D_load))
%B = (f_0/(2*H*S_B))*(P_delta - P_loss)

A1 = P_delta/M_1;
B1 = -k/M_1;
C1 = -(V_1*V_2*B_2)/M_1;
D1 = -(V_1*V_3*B_3)/M_1;

A2 = P_delta/M_2;
B2 = -k/M_2;
C2 = -(V_2*V_1*B_1)/M_2;
D2 = -(V_2*V_3*B_3)/M_2;


% f = @(t,X) [X(2); X(1) - X(1).^3 - delta*X(2)]; % + X(1).^2*X(2)]; % IT  WORKED FOR THIS ONE
%f = @(t,X) [X(2); A*X(1)+B];

f1 = @(t,X) [X(2); A1 + B1*X(2) + C1*sin(X(1) - X(3)) + D1*sin(X(1)); X(4); A2 + B2*X(3) + C2*sin(X(3) - X(1)) + D2*sin(X(3))];

% function from http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=1086115
%f = @(t,X) [X(2); -0.7143*X(2) + 0.234 - 0.0633*sin(X(1) + 0.0405) - 0.582*sin(X(1) + 0.4103)];

% To generate the phase portrait, we need to compute the derivatives $y_1'$ and $y_2'$ 
% at $t=0$ on a grid over the range of values for $y_1$ and $y_2$ we are interested in. 
% We will plot the derivatives as a vector at each (y1, y2) which will show us the initial 
% direction from each point. We will examine the solutions over the range -2 < y1 < 8, and 
% -2 < y2 < 2 for y2, and create a grid of 20x20 points.

y1 = linspace(-6,6,50);
y2 = linspace(-2.5,2.5,50);

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
    Yprime = f1(t,[x(i);y(i);x(i);y(i)]);
    u(i) = Yprime(1);
    v(i) = Yprime(2);
end

quiver(x,y,u,v,'r'); figure(gcf)
xlabel('x_1')
ylabel('x_2')
axis tight equal;

%% PLOT SOLUTIONS

hold on
for y10 = [-6 -5.5 -5 -4.5 -4 -3.5 -3 -2.5 -2 -1.5 -1 -0.5 0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6]
for y20 =  [-2.5 -2 -1.5 -1 -0.5 0 0.5 1 1.5 2 2.5] %[0 0.5 1 1.5 2 2.5]
    [ts,ys] = ode45(f1,[0,500],[y10;y20;0;0]); % [-0.5;y20] % t= 0.5 % [-1.5;y20]
    plot(ys(:,1)-ys(:,3),ys(:,2)-ys(:,4))
    [ts,ys] = ode45(f1,[0,500],[0;0;y10;y20]); % [-0.5;y20] % t= 0.5 % [-1.5;y20]
    plot(ys(:,1)-ys(:,3),ys(:,2)-ys(:,4))
    ylim([-2.5, 2.5])
    xlim([-6, 6])
    %plot(ys(1,1),ys(1,2),'bo') % starting point
    %plot(ys(end,1),ys(end,2),'ks') % ending point
end
end
hold off
