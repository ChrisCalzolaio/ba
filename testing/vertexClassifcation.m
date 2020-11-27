clearvars; clf;
[figH] = getFigH(1);
tH = tiledlayout(figH,3,2);
axH = gobjects(4,1);
for tl = 1:6
    axH(tl) = nexttile(tH,tl);
end
linkaxes(axH)
axis(axH,'equal');
axH(1).XLim = [-0.5 2];
axH(1).YLim = axH(1).XLim;
axSetup;
p1args = {'FaceColor','#D95319','FaceAlpha',0.25,'EdgeColor','none'};
p2args = {'FaceColor','#EDB120','FaceAlpha',0.25,'EdgeColor','none'};
poargs = {'FaceColor','#4DBEEE','FaceAlpha',0.25,'EdgeColor','none'};
toargs = {'Color','#A2142F','HorizontalAlignment','right'};
tnargs = {'Color','#77AC30'};

cID = {'i','w','t'};    % classification Identifiers
% i:    intersection. Punkt ist Verschneidung von workpiece und tool
% w:    workpiece. Punkt war ursprünglich Element der Werkstückwolke
% t:    tool. Punkt war ursprünglich Element der Werkzeugwolke
cCL = [[0 0.4470 0.7410];...        intersection
       [0.4660 0.6740 0.1880];...   workpiece
       [0.6350 0.0780 0.1840]];   % tool
   
% 1.Schnitt vorbereiten
poly1 = polyshape([0 0 1 1],[1 0 0 1],'KeepCollinearPoints',true);
sIDLuT = ones(4,1);                       % originale Vertex Klassi.: alle gehören Poly1
poly2 = translate(poly1,[0.25 0.75]);

for cut = 1:3
    % ausgangszustand plotten
    v1 = poly1.Vertices';
    patch(axH(2*cut-1),'XData',v1(1,:),'YData',v1(2,:),p1args{:});
    text(axH(2*cut-1),v1(1,:),v1(2,:),num2str((1:poly1.numsides)'));
    v2 = poly2.Vertices';
    patch(axH(2*cut-1),'XData',v2(1,:),'YData',v2(2,:),p2args{:});
    % schneiden
    [poly1,sID,vID] = poly1.subtract(poly2);
    resMat = [poly1.Vertices,sID,vID];
    vo = poly1.Vertices';
    % geschnittener Zustand plotten
    patch(axH(2*cut),'XData',vo(1,:),'YData',vo(2,:),poargs{:});
    sIDHo = text(axH(2*cut),vo(1,:),vo(2,:),cID(sID+1),toargs{:});          % ausgabe der unveränderten klassifizierung
    sID(sID ==1) = sIDLuT(vID(sID == 1));                                   % manipulation der aktuellen klassifizierung
    sIDHn = text(axH(2*cut),vo(1,:),vo(2,:),cID(sID+1),tnargs{:});          % ausgabe der veränderten klassifizierung
    sIDLuT = sID;                                                           % look up table: klassifizierung für den nächsten Schritt speichern
    % nächsten Schnitt vorbereiten
    if cut < 2
        poly2 = poly2.translate([0.25 -0.25]);
    else
        poly2 = poly2.translate([0 -0.25]);
    end
end