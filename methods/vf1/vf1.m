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
Bvec = B;
clearvars B
% plot
figH = getFigH(1,'WindowStyle',docked);
set(0,'CurrentFigure',figH);
tH = tiledlayout(figH,5,1);
axH(1) = nexttile(tH,1,[3 1]);
axH(2) = nexttile(tH,4);
axH(3) = nexttile(tH,5);
linkaxes(axH,'x');
% plot analytic trajectory
lH(1) = line(axH,shiftdim( Bvec),shiftdim(traj(3,nP,:)),'Color','#EDB120');

% legend('Z sim','Z iter');
% lH(3) = line(axH(2),shiftdim(Bsol(1,nP,:)),iters);
% lh(4) = line(axH(3),shiftdim(Bsol(1,nP,:)),err);


xlims = [0 2];
linkaxes(axH,'x')
% axH(1).XLim = xlims;
% axH.YLim = ylims;
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

% Definition der Funktion
bfun = @(B,z_soll) pi - phi_WZ + asin((z - c - z_soll + B*fZ_WZrad + sin(A)*(y + Y_shift + B*fY_WZrad - h_WZ))./(r_WZ*cos(A)));

%% Schritt N:

v1T = tic;
while runSim
    
    while not(engaged) % Seek-Loop
        B = B + dB;
        engaged = checkEng(cWZ,double(vpa(subs(mTM))),zInt,rWst);
        fprintf('Seeking. Angle %.2f°, Engagement: %s.\n',B,logStr{engaged + 1})
        lH(2) = line(axH(1),shiftdim(Bsol(1,nP,:)),z_soll,'color','#A2142F','Marker','.');
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
