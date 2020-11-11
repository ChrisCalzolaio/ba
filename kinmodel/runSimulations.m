% execute math script
out = evalc('hobbing');
% clearvars out ans
clearvars -except Gesamt
overallT = tic;

%% Bedatung der Variablen für die Simulation
% Werkstück offset
a = 0;
b = 0;
c = 0;
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
%% stop simulation
stopCrit = 'angB';

cStop = 2*pi;                               % simulation beenden wenn werkstück eine volle umdrehung gemacht
bStop = 2*pi;
switch stopCrit
    case 'angC'
        tSim = ang2t(cStop - ga, f_WSTrad, slopeB);  % Dauer der Simulation, bis cStop erreich ist, also vorgegebener Winkel C
    case 'angB'
        tSim = bStop/nB;
end
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
anaR = table();         % ergebnisse der simulation in analytischer Zeit
simR = table();         % ergebnisse der simulation in simulations zeit
% zeit
simR.t = simOut.tout;
anaR.t = anaT;
% winkel des werkstuecks
simAngC = simOut.logsout.find('angC');       % accessing the handle by getting the element for the required name doesn't break, when adding or removing logged signals
simR.AngC = simAngC.Values.Data;             % [rad]
anaR.AngC = interp1(simR.t,simR.AngC,anaR.t);
clearvars simAngC
% winkel des werkzeugs
simAngB = simOut.logsout.find('angB');
simR.AngB = simAngB.Values.Data;
anaR.AngB = interp1(simR.t,simR.AngB,anaR.t);
clearvars simAngB
% koordinaten des poi
simCord = simOut.logsout.find('poi_xyz');
simCord = simCord.Values.Data;             % [m] simulink returns an Nx3 matrix of vectors, we work with 3xN coordinat matricess
simR.Cord = simCord * 1e3; % [mm]
anaR.Cord = interp1(simR.t,simCord,anaR.t);
clearvars simCord

%% postprocessing
% get time
fprintf('[ %s ] time to run script: %.3f sec.\n',datestr(now,'HH:mm:ss'),toc(overallT))