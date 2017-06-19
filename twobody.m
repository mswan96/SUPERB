function dz = twobody(t,z)
dz = zeros(4,1);

f_0 = 50;
H_1 = 6;
H_2 = 6;
S_B = 115000;
k = 1.5;
D = (1/k);
P_delta = 3000;
P_loss = 0;
V_1 = 1;
V_2 = 1;
V_3 = 1;

M_1 = (2*H_1*S_B)/(2*pi*f_0);
M_2 = (2*H_2*S_B)/(2*pi*f_0);

B_1 = f_0/(2*H_1*S_B);
B_2 = f_0/(2*H_2*S_B);
B_3 = 0;

A1 = P_delta/M_1;
B1 = -k/M_1;
C1 = -(V_1*V_2*B_2)/M_1;
D1 = -(V_1*V_3*B_3)/M_1;

A2 = P_delta/M_2;
B2 = -k/M_2;
C2 = -(V_2*V_1*B_1)/M_2;
D2 = -(V_2*V_3*B_3)/M_2;

dz(1) = z(2);
dz(2) = A1 + B1*z(2) + C1*sin(z(1) - z(3)) + D1*sin(z(1));
dz(3) = z(4);
dz(4) = A2 + B2*z(4) + C1*sin(z(3) - z(1)) + D1*sin(z(3));




