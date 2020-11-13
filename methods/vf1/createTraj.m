%% Create Coordinates

d_WZ= 40;       % werkzeugdurchmesser
m = 3;          % Modul
al_n= 20;       % eingriffswinkel
h_f0f =1.4;     % fusshöhe
h_a0f= 1.17;    % kopfhöhe
z_WZ= 1;        % zähne werkzeug

[phi_WZ,r_WZ,h_WZ] = WZ(d_WZ, m, al_n, h_a0f, h_f0f, z_WZ);
[cWZ(1,:),cWZ(2,:),cWZ(3,:)] = pol2cart(phi_WZ,r_WZ,h_WZ);

clearvars -except cWZ

%% Create Trajectory
Gesamt = createGesamt();

fX_WZrad = 0;
x = 300;
fY_WZrad = 0;
y = 0;
Y_shift = 0;
fZ_WZrad = 0;
z = 75;
[a,b,c] = deal(0);
zWst = 50;
zWz = 1;
dirFac = -1;
f_WSTrad = zWz / zWst * dirFac;
ga = 0;
A = 0;

B(1,1,:) = linspace(0,2*pi,1e2);
TMgesamt = double(vpa(subs(Gesamt),16));
traj = applytm(cWZ,TMgesamt);
Bvec = B;
clearvars B