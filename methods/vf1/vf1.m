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

%% analytische Trajektorie:
[cWZ(1,:),cWZ(2,:),cWZ(3,:)] = pol2cart(phi_WZ,r_WZ,h_WZ);
B = [];                 % reset B
B(1,1,:) = linspace(0,3*pi,1e2);
TMgesamt = double(vpa(subs(mTM),16));
traj = applytm(cWZ,TMgesamt);
Bvec = shiftdim(B);                 % dimensions of Bvec to fit to traj
nP = 2;                             % select point for plotting
traj = reshape(traj(:,nP,:),3,[]);      % only regard the selected point for now
dist = vecnorm(traj(1:2,:),2,1);
traj = traj(3,:);      % only regard z-value of selected point for now
clearvars B
% plot
figH = getFigH(1,'WindowStyle','docked');
set(0,'CurrentFigure',figH);
tH = tiledlayout(figH,2,1);
axH(1) = nexttile(tH,1);
axH(2) = nexttile(tH,2);
% plot analytic trajectory, line trajectory handle
lTH(1) = line(axH(1), Bvec, traj,'Color','#EDB120');
% init line handles for seek and solution plots
lTH(2) = animatedline(axH(1), 'LineStyle','none','Marker','*','Color','#77AC30'); % seek
lTH(3) = animatedline(axH(1), 'LineStyle','-',   'Marker','.','Color','#A2142F'); % engaged traj

% plot analytic distance (radius) from centre axis
lRH(1) = line(axH(2), Bvec, dist,'Color','#D95319');
% init line handles for seek and solution plots
lRH(2) = animatedline(axH(2), 'LineStyle','none','Marker','*','Color','#77AC30'); % seek
lRH(3) = animatedline(axH(2), 'LineStyle','-',   'Marker','.','Color','#A2142F'); % engaged traj

% legend('Z sim','Z iter');
% lH(3) = line(axH(2),shiftdim(Bsol(1,nP,:)),iters);
% lh(4) = line(axH(3),shiftdim(Bsol(1,nP,:)),err);


xlims = [0 2*pi];
linkaxes(axH,'x')
axH(1).XLim = xlims;
axSetup();


%% Simulations-Setup
zInt = [15 90];         % [zmin zmax]
nSchritte = 1e2;        % diskrete Schritte in z-Richtung
iterAbbr = 1e-3;        % zulässiger Fehler bei der Iteration
dB = 0.1*pi;            % schrittweite beim seeken
logStr = {'no', 'yes'}; % logical string for log outputs
% preallocate variables
z_soll = linspace(zInt(2),zInt(1),nSchritte);
Bsol  = NaN(1,size(cWZ,2),nSchritte);   % Lösungsvektor
iters = NaN(nSchritte,1);               % Vektor der notwendigen Iterationsschritte
err   = NaN(nSchritte,1);               % vector of errors
zSolInd = NaN(nSchritte,1);             % vektor of Indizies der simulierten z Werte
% init variables
n = 0;                                  % absoluter zähler der simulierten Schritte
B = 0;                                  % Startwert für B
m = 1;                                  % index für z_soll                                 
engaged = false;                        % Werkzeug im Eingriff
runSim = true;                          % soll simulation ausgeührt werden
prevEng = false;                        % war Werkzeug beim vorherigen Iterationsschritt im Eingriff
% plot simulation setup information
line(axH(1),xlim,[zInt(2) zInt(2)],'LineStyle','--','Color','r');
line(axH(2),xlim,[rWst rWst],'LineStyle','--','Color','r');

% Definition der Funktion
bfun = @(B,z_soll) pi - phi_WZ + asin((z - c - z_soll + B*fZ_WZrad + sin(A)*(y + Y_shift + B*fY_WZrad - h_WZ))./(r_WZ*cos(A)));

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
        drawnow
    end
    
    while engaged   % Schnittschleife
        
        n = n+1;                        % weiterer schritt wird simuliert
        l = 0;                          % noch keine Iterationen
        
        while true      % Iterationsschleife
            l = l+1;                    % weitere Iteration ist notwendig
            B0 = B;                     % Ausgangswinkel der Iteration ist der Winkel des letzten Schrittes
            B  =  bfun(B0,z_soll(m));	% Berechnen des Winkels mit Startwert
            
            % Hardstop: gesuchter Wert z_soll tiefer als erreichbar
            if ~isreal(B)
                engaged = false;
                warning('Gesuchter Punkt zu tief.')
            else
                engaged = checkEng(cWZ,double(vpa(subs(mTM))),zInt,rWst);
            end
            
            % Iterationsschleifen Abbruch
            % entweder nicht mehr im Eingriff, oder genauigkeit erreicht
            div = sum(abs(B-B0));     % error
            if and(div>iterAbbr , engaged)
                err(n) =  div;   % Fehler mitloggen
            else
                break
            end
            
        end
        % Eregebnisser der Iteration wegschreiben
        Bsol(1,:,n) = B;
        zSolInd(n) = m;
        iters(n) = l;
        m = m+1;
    end
    % Schnitt ist beendet
    B = max(B);             % nur der Winkel des zuletzt im Eingriff gewesenen Punktes behalten
    B = B + pi/2;           % wir können um eine halbe Umdrehung springen
    m = 0;
    
    % simulation stop criterion
    curAngC = f_WSTrad * B + ga;
    if curAngC > StopCriterion
        runSim = false;
    end
end

% Ausgabe
fprintf('Dauer Lösung durch Iteration: %.4f sec.\n',toc(v1T))
