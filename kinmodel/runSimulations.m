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
traj = applytm(poi,TMgesamt);
fprintf('[ %s ] time to run the vectorized code: %.3f sec.\n',datestr(now,'HH:mm:ss'),toc(vecT))

if false
    iterT = tic;
    trajIter = nan(3,length(anaT));
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
simOut = sim('ASM00021');
fprintf('[ %s ] time to run the vectorized code: %.3f sec.\n',datestr(now,'HH:mm:ss'),toc(simulinkT))
%% Daten extrahieren
anaR = table();         % ergebnisse der simulation in analytischer Zeit
simR = table();         % ergebnisse der simulation in simulations zeit
sigs = {'angC','angB','poi_xyz'};
cols = {'angC','angB','simCord'};
% zeit
simR.t = simOut.tout;
anaR.t = anaT;
for sig = 1:numel(sigs)
    temp = simOut.logsout.find(sigs(sig));
    simR.(cols{sig}) = temp{1}.Values.Data;
    anaR.(cols{sig}) = interp1(simR.t,simR.(cols{sig}),anaR.t);
end
% write analytic coordinates to table
anaR.anaCord = traj';

%% postprocessing
% get time
fprintf('[ %s ] time to run script: %.3f sec.\n',datestr(now,'HH:mm:ss'),toc(overallT))
% cleanup
clearvars nSchritt simulinkT overallT vecT traj stopCrit temp cStop sig sigs cols