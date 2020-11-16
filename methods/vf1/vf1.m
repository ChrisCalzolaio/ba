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
ptID = 3;                             % select point for plotting
ptNm = numel(phi_WZ);
traj = reshape(traj(:,ptID,:),3,[]);      % only regard the selected point for now
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
Bsol  = NaN(1,ptNm,nSchritte);   % Lösungsvektor
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
figH = getFigH(2,'WindowStyle','docked');
% simulation key figures
set(0,'CurrentFigure',figH(1));
dH = waitbar(0,'Running sim...','Name','Running Sim','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(dH,'canceling',0);
tH = tiledlayout(figH(1),2,1);
tH.Padding = 'compact';
tH.TileSpacing = 'compact';
LegStr = {'trajectory','seek points','simulation'};
pH = pan(figH(1));
pH.Motion = 'horizontal';
pH.Enable = 'on';
% create axes handles
axH(1) = nexttile(tH,1);
axH(1).Title.String = 'Trajectory';
axH(1).XTickLabel = [];
axH(2) = nexttile(tH,2);
axH(2).Title.String = 'Distance';
linkaxes(axH,'x')
% 3d output
set(0,'CurrentFigure',figH(2))
ax3dH = axes(figH(2));
axis vis3d;
axSetup();
% plot analytic trajectory, line trajectory handle
lTH(1) = animatedline(axH(1),'Color','#EDB120');
% init line handles for seek and solution plots
lTH(2) = animatedline(axH(1), 'LineStyle','none','Marker','*','Color','#77AC30'); % seek
lTH(3) = animatedline(axH(1), 'LineStyle','-',   'Marker','.','Color','#A2142F'); % engaged traj
lTH(4) = animatedline(axH(1), 'LineStyle','--','Color','r','MaximumNumPoints',2); % upper workpiece limit
lTH(4).UserData.zInt = zInt(2);
legend(LegStr);

% plot analytic distance (radius) from centre axis
lRH(1) = animatedline(axH(2),'Color','#EDB120');
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
% 3d output
l3dHs = animatedline(ax3dH, 'LineStyle','none','Marker','*','Color','#77AC30'); % seek
l3dHc = animatedline(ax3dH, 'LineStyle','none','Marker','*','Color','y'); % cut candidate
% engaged traj
for ln = 1:ptNm
    l3dH(ln) = animatedline(ax3dH, 'LineStyle','-',   'Marker','.','Color','#A2142F');
end
xExt = 80;yExt = xExt;
patch(ax3dH,'XData',[xExt -xExt -xExt xExt],'YData',[yExt yExt -yExt -yExt],'ZData',repmat(max(zInt),1,4),'FaceColor','#D95319','FaceAlpha',0.25,'EdgeColor','none');
patch(ax3dH,'XData',[xExt -xExt -xExt xExt],'YData',[yExt yExt -yExt -yExt],'ZData',repmat(min(zInt),1,4),'FaceColor','#D95319','FaceAlpha',0.25,'EdgeColor','none');
[cWkstx,cWksty] = cylinder(rWst,1e2);
cWkstz = repmat(zInt',1,size(cWkstx,2));
surface(ax3dH,cWkstx,cWksty,cWkstz,'FaceColor','#D95319','FaceAlpha',0.25,'EdgeColor','none');
% Definition der Funktion

bfun = @(B,z_soll,k) k*pi - phi_WZ + asin((z - c - z_soll + B*fZ_WZrad + sin(A)*(y + Y_shift + B*fY_WZrad - h_WZ))./(r_WZ*cos(A)));
% tool angle to z-height
tAng2zH = @(B,nP) z - c + B *fZ_WZrad + sin(A)*(y + Y_shift + B*fY_WZrad - h_WZ(nP)) + r_WZ(nP) * cos(A) * sin(B + phi_WZ(nP));
posFun = @(B) [x.*cos(ga + B.*f_WSTrad) - b.*sin(ga + B.*f_WSTrad) - a.*cos(ga + B.*f_WSTrad) + B.*fX_WZrad.*cos(ga + B.*f_WSTrad) + r_WZ.*cos(phi_WZ).*(cos(ga + B.*f_WSTrad).*cos(B) - sin(ga + B.*f_WSTrad).*sin(A).*sin(B)) - r_WZ.*sin(phi_WZ).*(cos(ga + B.*f_WSTrad).*sin(B) + sin(ga + B.*f_WSTrad).*cos(B).*sin(A)) + Y_shift.*sin(ga + B.*f_WSTrad).*cos(A) - h_WZ.*sin(ga + B.*f_WSTrad).*cos(A) + y.*sin(ga + B.*f_WSTrad).*cos(A) + B.*fY_WZrad.*sin(ga + B.*f_WSTrad).*cos(A);... x-Komponente
                a.*sin(ga + B.*f_WSTrad) - x.*sin(ga + B.*f_WSTrad) - b.*cos(ga + B.*f_WSTrad) - r_WZ.*cos(phi_WZ).*(sin(ga + B.*f_WSTrad).*cos(B) + cos(ga + B.*f_WSTrad).*sin(A).*sin(B)) - B.*fX_WZrad.*sin(ga + B.*f_WSTrad) + r_WZ.*sin(phi_WZ).*(sin(ga + B.*f_WSTrad).*sin(B) - cos(ga + B.*f_WSTrad).*cos(B).*sin(A)) + Y_shift.*cos(ga + B.*f_WSTrad).*cos(A) - h_WZ.*cos(ga + B.*f_WSTrad).*cos(A) + y.*cos(ga + B.*f_WSTrad).*cos(A) + B.*fY_WZrad.*cos(ga + B.*f_WSTrad).*cos(A);... y-Komponente
                z - c + B.*fZ_WZrad + Y_shift.*sin(A) - h_WZ.*sin(A) + y.*sin(A) + B.*fY_WZrad.*sin(A) + r_WZ.*cos(A).*cos(B).*sin(phi_WZ) + r_WZ.*cos(A).*sin(B).*cos(phi_WZ)]; % z-Komponente
% position of tool point depending on tool angle
posFunID = @(B,ptID) [x.*cos(ga + B.*f_WSTrad) - b.*sin(ga + B.*f_WSTrad) - a.*cos(ga + B.*f_WSTrad) + B.*fX_WZrad.*cos(ga + B.*f_WSTrad) + r_WZ(ptID).*cos(phi_WZ(ptID)).*(cos(ga + B.*f_WSTrad).*cos(B) - sin(ga + B.*f_WSTrad).*sin(A).*sin(B)) - r_WZ(ptID).*sin(phi_WZ(ptID)).*(cos(ga + B.*f_WSTrad).*sin(B) + sin(ga + B.*f_WSTrad).*cos(B).*sin(A)) + Y_shift.*sin(ga + B.*f_WSTrad).*cos(A) - h_WZ(ptID).*sin(ga + B.*f_WSTrad).*cos(A) + y.*sin(ga + B.*f_WSTrad).*cos(A) + B.*fY_WZrad.*sin(ga + B.*f_WSTrad).*cos(A);... x-Komponente
                      a.*sin(ga + B.*f_WSTrad) - x.*sin(ga + B.*f_WSTrad) - b.*cos(ga + B.*f_WSTrad) - r_WZ(ptID).*cos(phi_WZ(ptID)).*(sin(ga + B.*f_WSTrad).*cos(B) + cos(ga + B.*f_WSTrad).*sin(A).*sin(B)) - B.*fX_WZrad.*sin(ga + B.*f_WSTrad) + r_WZ(ptID).*sin(phi_WZ(ptID)).*(sin(ga + B.*f_WSTrad).*sin(B) - cos(ga + B.*f_WSTrad).*cos(B).*sin(A)) + Y_shift.*cos(ga + B.*f_WSTrad).*cos(A) - h_WZ(ptID).*cos(ga + B.*f_WSTrad).*cos(A) + y.*cos(ga + B.*f_WSTrad).*cos(A) + B.*fY_WZrad.*cos(ga + B.*f_WSTrad).*cos(A);... y-Komponente
                      z - c + B.*fZ_WZrad + Y_shift.*sin(A) - h_WZ(ptID).*sin(A) + y.*sin(A) + B.*fY_WZrad.*sin(A) + r_WZ(ptID).*cos(A).*cos(B).*sin(phi_WZ(ptID)) + r_WZ(ptID).*cos(A).*sin(B).*cos(phi_WZ(ptID))]; % z-Komponente
% distance of tool point from workpiece centre depending on tool angle
distWst = @(B,ptID) sqrt((a.*sin(ga + B.*f_WSTrad) - x.*sin(ga + B.*f_WSTrad) - b.*cos(ga + B.*f_WSTrad) - r_WZ(ptID).*cos(phi_WZ(ptID)).*(sin(ga + B.*f_WSTrad).*cos(B) + cos(ga + B.*f_WSTrad).*sin(A).*sin(B)) - B.*fX_WZrad.*sin(ga + B.*f_WSTrad) + r_WZ(ptID).*sin(phi_WZ(ptID)).*(sin(ga + B.*f_WSTrad).*sin(B) - cos(ga + B.*f_WSTrad).*cos(B).*sin(A)) + Y_shift.*cos(ga + B.*f_WSTrad).*cos(A) - h_WZ(ptID).*cos(ga + B.*f_WSTrad).*cos(A) + y.*cos(ga + B.*f_WSTrad).*cos(A) + B.*fY_WZrad.*cos(ga + B.*f_WSTrad).*cos(A)).^2 + (x.*cos(ga + B.*f_WSTrad) - b.*sin(ga + B.*f_WSTrad) - a.*cos(ga + B.*f_WSTrad) + B.*fX_WZrad.*cos(ga + B.*f_WSTrad) + r_WZ(ptID).*cos(phi_WZ(ptID)).*(cos(ga + B.*f_WSTrad).*cos(B) - sin(ga + B.*f_WSTrad).*sin(A).*sin(B)) - r_WZ(ptID).*sin(phi_WZ(ptID)).*(cos(ga + B.*f_WSTrad).*sin(B) + sin(ga + B.*f_WSTrad).*cos(B).*sin(A)) + Y_shift.*sin(ga + B.*f_WSTrad).*cos(A) - h_WZ(ptID).*sin(ga + B.*f_WSTrad).*cos(A) + y.*sin(ga + B.*f_WSTrad).*cos(A) + B.*fY_WZrad.*sin(ga + B.*f_WSTrad).*cos(A)).^2);

%% Schritt N:
v1T = tic;
while runSim
    % plot trajectory
    bvec = linspace(B,B+2*pi,1e2);
    addpoints(lTH(1),bvec,tAng2zH(bvec,ptID));
    addpoints(lRH(1),bvec,distWst(bvec,ptID));
    while not(engaged) % Seek-Loop
        B = B + dB;
        engaged = checkEng(posFun(B),zInt,rWst);
        addpoints(lTH(2),B,tAng2zH(B,ptID));
        addpoints(lRH(2),B,distWst(B,ptID));
        aktPos = posFun(repmat(B,1,4));
        addpoints(l3dHs,aktPos(1,:),aktPos(2,:),aktPos(3,:))
        scrollPlot(axH,limH,B);
    end
    
    while true
        B0 = B;                     % Ausgangswinkel der Iteration ist der Winkel des letzten Schrittes
        B  =  bfun(B0,z_soll(m),k);	% Berechnen des Winkels mit Startwert
        engaged = checkEng(posFun(B),zInt,rWst);
        if engaged
            prevm = m;              % save z-height we engaged at, this is where we will start next time
            break
        else
            cutC = posFun(B);
            addpoints(l3dHc,cutC(1,:),cutC(2,:),cutC(3,:));
            m = m+1;
        end
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
        engaged = checkEng(posFun(B),zInt,rWst);
        if not(engaged)
            break
        end
        n = n+1;                    % ein weiterer, gültiger Schritt wurde simuliert
        % plotten des punktes
        addpoints(lTH(3),B(ptID), tAng2zH(B(ptID),ptID));
        addpoints(lRH(3),B(ptID), distWst(B(ptID),ptID));
        scrollPlot(axH,limH,B(ptID));
        aktPos = posFun(B);
        for ln = 1:ptNm
            addpoints(l3dH(ln),aktPos(1,ln),aktPos(2,ln),aktPos(3,ln))
        end
        % Ergebnisse wegschreiben
        Bsol(1,:,n) = B;
        zSolInd(n) = m;
        iters(n) = l;
        err(n) =  div;   % Fehler mitloggen
        
        m = m+1;
    end
    % Schnitt ist beendet
    B = max(B);             % nur der Winkel des zuletzt im Eingriff gewesenen Punktes behalten
    B = B + pi;             % wir können um eine halbe Umdrehung springen
    m = prevm;              % wieder bei der letzten obersten Ebene beginnen
    k = k+2;
    addpoints(lTH(3),B,NaN);
    addpoints(lRH(3),B,NaN);
    for ln = 1:ptNm
        addpoints(l3dH(ln),NaN,NaN,NaN)
    end
    
    % simulation stop criterion
    curAngC = abs(f_WSTrad * B + ga);
    fprintf('Cut finished. Workpiece is at %.3f rad.\n', curAngC);
    if curAngC > StopCriterion
        runSim = false;
    end
    if getappdata(dH,'canceling')
        break
    end
end

% Ausgabe
fprintf('Dauer Lösung durch Iteration: %.4f sec.\n',toc(v1T))
delete(dH);