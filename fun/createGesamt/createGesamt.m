function tm = createGesamt()
%CREATE Summary of this function goes here
%   Detailed explanation goes here

% B-Achse
syms B
R_B = axang2rtm('y',-B);
% A-Achse
syms A
R_A = axang2rtm('x',A);
% C-Achse
syms C ga f_WSTrad
C = f_WSTrad * B + ga;
R_Cga = axang2rtm('z', C);
% rotiertes Werkzeugkoordinatensystem
R_Wkz = fix(axang2rtm('x',pi/2));
% Y-Achse
syms y fY_WZrad Y_shift
T_Ys = trvecHomTform('y',y + fY_WZrad*B + Y_shift);
% X- und Z-Achse
syms x z
T_XZ = trvecHomTform('x',x,'z',z);
syms fZ_WZrad fX_WZrad
T_XZf = trvecHomTform('x',fX_WZrad*B,'z',fZ_WZrad*B);
T_XZ = T_XZ * T_XZf;
% Offset Arbeitstisch
syms a b c
T_offs = trvecHomTform([a,b,c]);
% Transformation Werkzeug -> Maschine
Tm_Wkz = T_XZ * R_A * T_Ys * R_B * R_Wkz;
% Transformation Werkstück -> Maschine
Tm_Wst = T_offs * R_Cga;
% Gesamt
tm = simplify(Tm_Wst \ Tm_Wkz);
end

