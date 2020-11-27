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

% 1.Schnitt vorbereiten
poly1 = polyshape([0 0 1 1],[1 0 0 1],'KeepCollinearPoints',true);
sIDLuT = ones(4,1);                       % originale Vertex Klassi.: alle gehören Poly1
poly2 = translate(poly1,[0.25 0.75]);

for cut = 1:3
    % ausgangszustand plotten
    v1 = poly1.Vertices';
    patch(axH(2*cut-1),'XData',v1(1,:),'YData',v1(2,:),'FaceColor','#D95319','FaceAlpha',0.25,'EdgeColor','none');
    text(axH(2*cut-1),v1(1,:),v1(2,:),num2str((1:poly1.numsides)'));
    v2 = poly2.Vertices';
    patch(axH(2*cut-1),'XData',v2(1,:),'YData',v2(2,:),'FaceColor','#EDB120','FaceAlpha',0.25,'EdgeColor','none');
    % schneiden
    [poly1,sID,vID] = poly1.subtract(poly2);
    resMat = [poly1.Vertices,sID,vID];
    vo = poly1.Vertices';
    % geschnittener Zustand plotten
    patch(axH(2*cut),'XData',vo(1,:),'YData',vo(2,:),'FaceColor','#4DBEEE','FaceAlpha',0.25,'EdgeColor','none');
    sIDHo = text(axH(2*cut),vo(1,:),vo(2,:),num2str(sID),'Color','#A2142F','HorizontalAlignment','right');          % ausgegebene Klassifizierung
    sID(sID ==1) = sIDLuT(vID(sID == 1));	% manipulation der aktuellen klassifizierung
    sIDHn = text(axH(2*cut),vo(1,:),vo(2,:),num2str(sID),'Color','#77AC30');
    sIDLuT = sID;                         % look up table: klassifizierung für den nächsten Schritt speichern
    % nächsten Schnitt vorbereiten
    poly2 = poly2.translate([0.25 -0.25]);
end