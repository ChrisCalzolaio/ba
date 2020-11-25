[figH] = getFigH(1);
tH = tiledlayout(figH,2,2);
axH = gobjects(4,1);
for tl = 1:4
    axH(tl) = nexttile(tH,tl);
end
linkaxes(axH)
axis(axH,'equal');
axH(1).XLim = [-0.5 2];
axH(1).YLim = axH(1).XLim;
axSetup;

% 1.Schnitt vorbereiten
poly1 = polyshape([0 0 1 1],[1 0 0 1],'KeepCollinearPoints',true);
v1 = poly1.Vertices';
patch(axH(1),'XData',v1(1,:),'YData',v1(2,:),'FaceColor','#D95319','FaceAlpha',0.25,'EdgeColor','none');
poly2 = translate(poly1,[0.5 0.5]);
v2 = poly2.Vertices';
patch(axH(1),'XData',v2(1,:),'YData',v2(2,:),'FaceColor','#EDB120','FaceAlpha',0.25,'EdgeColor','none');
% 1. schnitt
[polyout,sID,vID] = poly1.subtract(poly2);
resMat = [polyout.Vertices,sID,vID];
vo = polyout.Vertices';
patch(axH(2),'XData',vo(1,:),'YData',vo(2,:),'FaceColor','#4DBEEE','FaceAlpha',0.25,'EdgeColor','none');
sIDH = text(axH(2),vo(1,:),vo(2,:),num2str(sID));
% 2.Schnitt vorbereiten
poly22 = poly2.translate([0.1 -0.25]);
v22 = poly22.Vertices';
patch(axH(3),'XData',v22(1,:),'YData',v22(2,:),'FaceColor','#EDB120','FaceAlpha',0.25,'EdgeColor','none');
patch(axH(3),'XData',vo(1,:),'YData',vo(2,:),'FaceColor','#4DBEEE','FaceAlpha',0.25,'EdgeColor','none');
% 2. Schnitt
[polyout2,sID2,vID2] = polyout.subtract(poly22);
resMat2 = [polyout2.Vertices,sID2,vID2];
vo2 = polyout2.Vertices';
patch(axH(4),'XData',vo2(1,:),'YData',vo2(2,:),'FaceColor','#4DBEEE','FaceAlpha',0.25,'EdgeColor','none');

sID2t(sID2 ==1) = sID(vID2(sID2 ==1));

sIDH2 = text(axH(4),vo2(1,:),vo2(2,:),num2str(sID2t));