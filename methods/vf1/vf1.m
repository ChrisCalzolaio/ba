clearvars
%% Schritt 0:
% Werkzeug
m=3;                % Modul
al_n= 20;           % Eingriffswinkel
z_WST= 24;          % Zähnezahl
rWst = (m*z_WST)/2; % Werkstückradius
d_WZ= 40;           % Werkzeugdurchmesser
rWz = d_WZ/2;       % Werkzeugradius
z_WZ= 1;            % Werkzeug Zähnezahl
h_f0f =1.4;         % Werkzeug Kopf- und Fußhöhe
h_a0f= 1.17;
% Erzeugung der Werkzeugpunkte
[phi_WZ,r_WZ,h_WZ] = WZ(d_WZ, m, al_n, h_a0f, h_f0f, z_WZ);
% Maschine

x = rWst + rWz;
fX_WZrad=0;

fY_WZrad = 0;
y = 0;
Y_shift = 0;

fZ_WZrad = 0;
z = 75;

[a,b,c] = deal(0);
dirFac = -1;
f_WSTrad = z_WZ / z_WST * dirFac;
ga = 0;

A = 0;

mTM = createGesamt();   % Maschinentransformationsmatrix laden
mTM = subs(mTM);

%% analytische Trajektorie:
[cWZ(1,:),cWZ(2,:),cWZ(3,:)] = pol2cart(phi_WZ,r_WZ,h_WZ);
B = [];                 % reset B
B(1,1,:) = linspace(0,3*pi,1e2);
TMgesamt = double(vpa(subs(mTM),16));
traj = applytm(cWZ,TMgesamt);
Bvec = shiftdim(B);                 % dimensions of Bvec to fit to traj
nP = 3;                             % select point for plotting
traj = reshape(traj(:,nP,:),3,[]);      % only regard the selected point for now
dist = vecnorm(traj(1:2,:),2,1);
traj = traj(3,:);      % only regard z-value of selected point for now
clearvars B

%% Simulations-Setup
zInt = [15 90];         % [zmin zmax]
nSchritte = 1e2;        % diskrete Schritte in z-Richtung
iterAbbr = 1e-3;        % zulässiger Fehler bei der Iteration
dB = 0.1*pi;            % schrittweite beim seeken
logStr = {'no', 'yes'}; % logical string for log outputs
StopCriterion = 2*pi;
% preallocate variables
z_soll = linspace(zInt(2),zInt(1),nSchritte);
Bsol  = NaN(1,size(cWZ,2),nSchritte);   % Lösungsvektor
iters = NaN(nSchritte,1);               % Vektor der notwendigen Iterationsschritte
err   = NaN(nSchritte,1);               % vector of errors
zSolInd = NaN(nSchritte,1);             % vektor of Indizies der simulierten z Werte
% init variables
n = 1;                                  % absoluter zähler der simulierten Schritte
B = 0;                                  % Startwert für B
m = 1;                                  % index für z_soll
k = 1;
validIter = true;
engaged = false;                        % Werkzeug im Eingriff
runSim = true;                          % soll simulation ausgeührt werden
prevEng = false;                        % war Werkzeug beim vorherigen Iterationsschritt im Eingriff
% plot
LegStr = {'trajectory','seek points','simulation'};
figH = getFigH(1,'WindowStyle','docked');
set(0,'CurrentFigure',figH);
tH = tiledlayout(figH,2,1);
tH.Padding = 'compact';
tH.TileSpacing = 'compact';

axH(1) = nexttile(tH,1);
axH(1).Title.String = 'Trajectory';
axH(1).XTickLabel = [];
axH(2) = nexttile(tH,2);
axH(2).Title.String = 'Distance';
linkaxes(axH,'x')
axSetup();
% plot analytic trajectory, line trajectory handle
lTH(1) = line(axH(1), Bvec, traj,'Color','#EDB120');
% init line handles for seek and solution plots
lTH(2) = animatedline(axH(1), 'LineStyle','none','Marker','*','Color','#77AC30'); % seek
lTH(3) = animatedline(axH(1), 'LineStyle','-',   'Marker','.','Color','#A2142F'); % engaged traj
lTH(4) = animatedline(axH(1), 'LineStyle','--','Color','r','MaximumNumPoints',2); % upper workpiece limit
lTH(4).UserData.zInt = zInt(2);
legend(LegStr);

% plot analytic distance (radius) from centre axis
lRH(1) = line(axH(2), Bvec, dist,'Color','#EDB120');
% init line handles for seek and solution plots
lRH(2) = animatedline(axH(2), 'LineStyle','none','Marker','*','Color','#77AC30'); % seek
lRH(3) = animatedline(axH(2), 'LineStyle','-',   'Marker','.','Color','#A2142F'); % engaged traj
lRH(4) = animatedline(axH(2), 'LineStyle','--','Color','r','MaximumNumPoints',2); % outer workpiece limit
lRH(4).UserData.zInt = rWst;
legend(LegStr);
% scrollender plot
axH = axH(1);       % only the main axes handle is required
% default
axH.UserData.xlims = [0 2*pi];
% scrollende x Achse
axH.UserData.scroll = [-6/4*pi 2/4*pi];
limH = [lTH(4) lRH(4)];
% Definition der Funktion
bfun = @(B,z_soll,k) k*pi - phi_WZ + asin((z - c - z_soll + B*fZ_WZrad + sin(A)*(y + Y_shift + B*fY_WZrad - h_WZ))./(r_WZ*cos(A)));

%% Schritt N:
v1T = tic;
while runSim
    
    while not(engaged) % Seek-Loop
        B = B + dB;
        engaged = checkEng(cWZ,double(vpa(subs(mTM))),zInt,rWst);
        zEst = traj(findBest(Bvec,B));
        rEst = dist(findBest(Bvec,B));
        fprintf('Seeking. Angle %.3f rad @ z: %.3f, Engagement: %s.\n',B,zEst,logStr{engaged + 1})
        addpoints(lTH(2),B,zEst);
        addpoints(lRH(2),B,rEst);
        scrollPlot(axH,limH,B);
    end
        
    while engaged   % Schnittschleife
        
        l = 0;                          % noch keine Iterationen
        
        while true      % Iterationsschleife
            l = l+1;                    % weitere Iteration ist notwendig
            B0 = B;                     % Ausgangswinkel der Iteration ist der Winkel des letzten Schrittes
            B  =  bfun(B0,z_soll(m),k);	% Berechnen des Winkels mit Startwert
            
            % Hardstop: gesuchter Wert z_soll tiefer als erreichbar
            if ~isreal(B)
                validIter = false;
                B = B0;                 % letzter berechneter Wert ist der gültige Endwinkel
                warning('Gesuchter Punkt zu tief.')
            end
            
            % Iterationsschleifen Abbruch
            % entweder nicht mehr im Eingriff, oder genauigkeit erreicht
            div = sum(abs(B-B0));     % error
            if div > iterAbbr
            else
                break
            end
            
        end

        if not(validIter)
            validIter = true;       % reset flag
            engaged = false;        % durch erreichen eines ungültigen Iterationszustandes sind wir auch nicht mehr im Eingriff
            break
        end
        % prüfen, ob wir noch im Eingriff sind
        engaged = checkEng(cWZ,double(vpa(subs(mTM))),zInt,rWst);        
        if not(engaged)
            break
        end
        n = n+1;                    % ein weiterer, gültiger Schritt wurde simuliert
        % plotten des punktes
        zEst = traj(findBest(Bvec,B(nP)));
        rEst = dist(findBest(Bvec,B(nP)));
        addpoints(lTH(3),B(nP),zEst);
        addpoints(lRH(3),B(nP),rEst);
        scrollPlot(axH,limH,B(nP));
        % Ergebnisse wegschreiben
        Bsol(1,:,n) = B;
        zSolInd(n) = m;
        iters(n) = l;
        err(n) =  div;   % Fehler mitloggen
        
        m = m+1;
    end
    % Schnitt ist beendet
    B = max(B);             % nur der Winkel des zuletzt im Eingriff gewesenen Punktes behalten
    B = B + pi/2;           % wir können um eine halbe Umdrehung springen
    k = k+2;
    m = 1;
    
    % simulation stop criterion
    curAngC = abs(f_WSTrad * B + ga);
    fprintf('Cut finished. Workpiece is at %.3f rad.\n', curAngC);
    if curAngC > StopCriterion
        runSim = false;
    end
end

% Ausgabe
fprintf('Dauer Lösung durch Iteration: %.4f sec.\n',toc(v1T))
