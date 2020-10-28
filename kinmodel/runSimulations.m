% execute math script
out = evalc('hobbing');
% clearvars out ans
clearvars -except Gesamt
overallT = tic;

%% Bedatung der Variablen für die Simulation
% Werkstück offset
a = 0;
b = 0;
c = 50;
% point of interest
poi = [-60 0 -11.4937]';      % [mm] punkt in werkzeugkoordinaten

%% Vorschübe
% x-Achse
fX_WZrad = 0;
x = 300;    % [mm] abstand in CSYS zu WZ-CS
% z-Achse
fZ_WZrad = 0;
z = 75;     % [mm] abstand in CSYS zu WZ-CS
% y-Achse
fY_WZrad = 0;
y = 0;
Y_shift = 0;
% C-Achse
zWst = 50;              % zähnezahl werkstuck
zWz = 1;                % zähnezahl werkzeug
dirFac = -1;            % definiert Drehrichtung der Spirale (pos: Rechtsgewinde)
f_WSTrad = zWz / zWst * dirFac;
ga = 0;                 % werkstuckwinkel offset
% A-Achse
A = 0;          % winkel A in rad
%% Berechnung
% Simulations Setup
nB = 1;         % [1*s^-1], drehzahl der b-achse
slopeB = nB;    % drehgechwindigkeit, eigentlich die Ableitung
% stop simulation
cStop = 2*pi;       % simulation beenden wenn werkstück eine volle umdrehung gemacht
tSim = abs((cStop - ga)/(f_WSTrad*slopeB)); % Dauer der Simulation, bis cStop erreich ist, also vorgegebener Winkel C
% tSim = 64*pi;

% analytische Berechnung
nSchritt = 1e3;

anaT = linspace(0,tSim,nSchritt+1)';        % time for analytic calculation
B(1,1,:) = slopeB .* anaT;

currB = 0;
vecT = tic;
TMgesamt = double(vpa(subs(Gesamt),16));
trajvec = applytm(poi,TMgesamt);
fprintf('[ %s ] time to run the vectorized code: %.3f sec.\n',datestr(now,'HH:mm:ss'),toc(vecT))

if false
    iterT = tic;
    trajIter = nan(3,length(anaT));
    % 1:nSchritt+1
    for schritt = 1:length(anaT)
        currB = slopeB * anaT(schritt);
        B = currB;
        TMgesamt = double(vpa(subs(Gesamt)));
        trajIter(:,schritt) = applytm(poi,TMgesamt);
        %     traj(schritt,:) = app
    end
    fprintf('[ %s ] time to run the iteration: %.3f sec.\n',datestr(now,'HH:mm:ss'),toc(iterT))
end

% Simulation
simulinkT = tic;
traj = trajvec;
simOut = sim('ASM00021');
fprintf('[ %s ] time to run the vectorized code: %.3f sec.\n',datestr(now,'HH:mm:ss'),toc(simulinkT))
%% Daten extrahieren
% zeit
simT = simOut.logsout{1}.Values.Time;
% winkel des werkstuecks
simAng = simOut.logsout{1}.Values.Data'; % [rad]
simAngRS = interp1(simT,simAng',anaT)';
% koordinaten des poi
simCord = simOut.logsout{2}.Values.Data'; % [m] simulink return an Nx3 matrix of vectors, we work with 3xN coordinat matricess
simCord = simCord * 1e3; % [mm]
simCordRS = interp1(simT,simCord',anaT)';
% get time
fprintf('[ %s ] time to run script: %.3f sec.\n',datestr(now,'HH:mm:ss'),toc(overallT))
