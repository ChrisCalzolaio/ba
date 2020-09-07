syms C ga a b c X Y Y_shift Z A B
syms x_WZ y_WZ z_WZ 
syms r_WZ phi_WZ h_WZ
syms fZ_WZrad fY_WZrad fX_WZrad f_WSTrad z_soll
C= f_WSTrad * B
R_B=   [cos(-B) 0 sin(-B) 0; 0 1 0 0; -sin(-B) 0 cos(-B) 0; 0 0 0 1]
T_Ys=  [1 0 0 0; 0 1 0 Y+fY_WZrad*B+Y_shift; 0 0 1 0; 0 0 0 1]
R_A=   [1 0 0 0; 0 cos(A) -sin(A) 0; 0 sin(A) cos(A) 0; 0 0 0 1]
T_XZ=  [1 0 0 X+fX_WZrad*B-a; 0 1 0 -b; 0 0 1 Z+fZ_WZrad*B-c; 0 0 0 1]
R_Cga= [cos(-C+ga) -sin(-C+ga) 0 0; sin(-C+ga) cos(-C+ga) 0 0; 0 0 1 0; 0 0 0 1]
Gesamt= R_Cga * T_XZ * R_A * T_Ys * R_B

p_WST = Gesamt * [x_WZ;y_WZ;z_WZ;1]
p_WST = Gesamt * [r_WZ*cos(phi_WZ);h_WZ;r_WZ*sin(phi_WZ);1]

%[ cos(ga - B*f_WSTrad)*cos(B) + sin(ga - B*f_WSTrad)*sin(A)*sin(B), -sin(ga - B*f_WSTrad)*cos(A),   sin(ga - B*f_WSTrad)*cos(B)*sin(A) - cos(ga - B*f_WSTrad)*sin(B), b*sin(ga - B*f_WSTrad) + cos(ga - B*f_WSTrad)*(X - a + B*fX_WZrad) - sin(ga - B*f_WSTrad)*cos(A)*(Y + Y_shift + B*fY_WZrad)]
%[ sin(ga - B*f_WSTrad)*cos(B) - cos(ga - B*f_WSTrad)*sin(A)*sin(B),  cos(ga - B*f_WSTrad)*cos(A), - sin(ga - B*f_WSTrad)*sin(B) - cos(ga - B*f_WSTrad)*cos(B)*sin(A), sin(ga - B*f_WSTrad)*(X - a + B*fX_WZrad) - b*cos(ga - B*f_WSTrad) + cos(ga - B*f_WSTrad)*cos(A)*(Y + Y_shift + B*fY_WZrad)]
%[                                                    cos(A)*sin(B),                       sin(A),                                                      cos(A)*cos(B),                                                                      Z - c + B*fZ_WZrad + sin(A)*(Y + Y_shift + B*fY_WZrad)]
%[                                                                0,                            0,                                                                  0,                                                                                                                           1]

% Z - c + B*fZ_WZrad + sin(A)*(Y + Y_shift + B*fY_WZrad) + h_WZ*sin(A) + r_WZ*cos(A)*cos(B)*sin(phi_WZ) + r_WZ*cos(A)*sin(B)*cos(phi_WZ)
% Z - c + B*fZ_WZrad + sin(A)*(Y + Y_shift + B*fY_WZrad) + h_WZ*sin(A) + r_WZ*cos(A)*(sin(B + phi_WZ)

% solve( z_soll == Z - c + B*fZ_WZrad + sin(A)*(Y + Y_shift + B*fY_WZrad) + h_WZ*sin(A) + r_WZ*cos(A)*(sin(B + phi_WZ)) , B )
% Verfahren 1:
% Schritt 1: B auf einen Schätzwert festlegen, 0 pi/2 pi etc. je nach dem wo die B-Achse startet und wie die WZ-Schneide liegt
% Schritt 2: B ausrechnen: B= arcsin((z_soll - (Z - c + B*f_WZrad + sin(A)*(Y + Y_shift) + h_WZ*sin(A))))/(r_WZ*cos(A)) - phi_WZ 
% Schritt N: Schritt 2 mit neuem B durchführen bis Differenz zwischen B alt und B neu < gewählter Toleranz
% Alternativ: nach Schritt 2:  mit fzero lösen 0 == Z - c + B*fZ_WZrad + sin(A)*(Y + Y_shift + B*fY_WZrad) + h_WZ*sin(A) + r_WZ*cos(A)*(sin(B + phi_WZ))-Z_soll nach B 

% Verfahren 2:
% sin Approx. nutzen
phi= linspace(-pi,pi,101);
plot(phi,sin(phi),'-g', phi, 1.27323954 * phi - sign(phi) .* 0.405284735 .* phi.^2,'-b')

k1= 1.27323954; k2=0.405284735;
%solve (z_soll -(Z- c + sin(A)*(Y + Y_shift) + h_WZ*sin(A)) == B*fZ_WZrad  + r_WZ*cos(A)*(sin(B + phi_WZ)) , B )
syms k3
%solve (k3 == B*fZ_WZrad  + r_WZ*cos(A)*(sin(B + phi_WZ)) , B )
%solve (k3 == B*fZ_WZrad  + r_WZ*cos(A)*(k1*(B + phi_WZ) - sign(B + phi_WZ)*k2*(B + phi_WZ)^2),B)
solve (k3 == B*fZ_WZrad  + r_WZ*cos(A)*(k1*(B + phi_WZ) - k2*(B + phi_WZ)^2),B)
solve (k3 == B*fZ_WZrad  + r_WZ*cos(A)*(k1*(B + phi_WZ) + k2*(B + phi_WZ)^2),B)

% R_Cga =
% [ cos(ga - B*f_WSTrad), -sin(ga - B*f_WSTrad), 0, 0]
% [ sin(ga - B*f_WSTrad),  cos(ga - B*f_WSTrad), 0, 0]
% [                    0,                     0, 1, 0]
% [                    0,                     0, 0, 1]

% T_XZ * R_A * T_Ys * R_B=
% [         cos(B),      0,        -sin(B),                                     X - a + B*fX_WZrad]
% [ -sin(A)*sin(B), cos(A), -cos(B)*sin(A),                  cos(A)*(Y + Y_shift + B*fY_WZrad) - b]
% [  cos(A)*sin(B), sin(A),  cos(A)*cos(B), Z - c + B*fZ_WZrad + sin(A)*(Y + Y_shift + B*fY_WZrad)]
% [              0,      0,              0,                                                      1]

% [T_XZ * R_A * T_Ys * R_B] * [r_WZ*cos(phi_WZ);h_WZ;r_WZ*sin(phi_WZ);1]
%                                                                  X - a + B*fX_WZrad + r_WZ*cos(B)*cos(phi_WZ) - r_WZ*sin(B)*sin(phi_WZ)
%                   cos(A)*(Y + Y_shift + B*fY_WZrad) - b + h_WZ*cos(A) - r_WZ*cos(B)*sin(A)*sin(phi_WZ) - r_WZ*sin(A)*sin(B)*cos(phi_WZ)
%  Z - c + B*fZ_WZrad + sin(A)*(Y + Y_shift + B*fY_WZrad) + h_WZ*sin(A) + r_WZ*cos(A)*cos(B)*sin(phi_WZ) + r_WZ*cos(A)*sin(B)*cos(phi_WZ)

syms B_1
solve(Z - c + B_1*fZ_WZrad + sin(A)*(Y + Y_shift + B_1*fY_WZrad) + h_WZ*sin(A) + cos(A)*r_WZ.*sin(B-phi_WZ)==z_soll, B)
%      phi_WZ - asin((Z - c - z_soll + B_1*fZ_WZrad + sin(A)*(Y + Y_shift + B_1*fY_WZrad) + h_WZ*sin(A))/(r_WZ*cos(A)))
% phi_WZ + pi + asin((Z - c - z_soll + B_1*fZ_WZrad + sin(A)*(Y + Y_shift + B_1*fY_WZrad) + h_WZ*sin(A))/(r_WZ*cos(A)))
