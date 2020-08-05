syms C ga a b c X Y s Z A B
syms x_WZ y_WZ z_WZ
syms f_WZrad f_WSTrad z_soll
Z= f_WZrad * B
C= f_WSTrad * B
R_B=   [cos(-B) 0 sin(-B) 0; 0 1 0 0; -sin(-B) 0 cos(-B) 0; 0 0 0 1]
T_Ys=  [1 0 0 0; 0 1 0 Y+s; 0 0 1 0; 0 0 0 1]
R_A=   [1 0 0 0; 0 cos(-A) -sin(A) 0; 0 sin(-A) cos(-A) 0; 0 0 0 1]
T_XZ=  [1 0 0 X-a; 0 1 0 -b; 0 0 1 Z-c; 0 0 0 1]
R_Cga= [cos(-C+ga) -sin(-C+ga) 0 0; sin(-C+ga) cos(-C+ga) 0 0; 0 0 1 0; 0 0 0 1]
Gesamt= R_Cga * T_XZ * R_A * T_Ys * R_B

p_WST = Gesamt * [x_WZ;y_WZ;z_WZ;1]

%[ cos(ga - B*f_WSTrad)*cos(B) + sin(ga - B*f_WSTrad)*sin(A)*sin(B), -sin(ga - B*f_WSTrad)*cos(A),   sin(ga - B*f_WSTrad)*cos(B)*sin(A) - cos(ga - B*f_WSTrad)*sin(B), b*sin(ga - B*f_WSTrad) + cos(ga - B*f_WSTrad)*(X - a) - sin(ga - B*f_WSTrad)*cos(A)*(Y + s)]
%[ sin(ga - B*f_WSTrad)*cos(B) - cos(ga - B*f_WSTrad)*sin(A)*sin(B),  cos(ga - B*f_WSTrad)*cos(A), - sin(ga - B*f_WSTrad)*sin(B) - cos(ga - B*f_WSTrad)*cos(B)*sin(A), sin(ga - B*f_WSTrad)*(X - a) - b*cos(ga - B*f_WSTrad) + cos(ga - B*f_WSTrad)*cos(A)*(Y + s)]
%[                                                    cos(A)*sin(B),                      -sin(A),                                                      cos(A)*cos(B),                                                              B*f_WZrad - c - sin(A)*(Y + s)]
%[                                                                0,                            0,                                                                  0,                                                                                           1]

solve( z_soll == B*f_WZrad - c - sin(A)*(Y + s) - y_WZ*sin(A) + z_WZ*cos(A)*cos(B) + x_WZ*cos(A)*sin(B) , B )
