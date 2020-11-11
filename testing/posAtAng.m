%% graphics
[figH,axH] = getFigH(1,'WindowStyle','keep');
set(0,'CurrentFigure',figH);
tH = tiledlayout(figH,5,1);

axH(1) = nexttile(tH,1,[3 1]);
lH(1) = line(axH,anaR.angB,anaR.simCord(:,3),'Color','#EDB120');
lH(2) = line(Bsol,z_soll,'color','#A2142F','Marker','.');
legend('Z sim','Z iter');

axH(2) = nexttile(tH,4);
lH(3) = line(Bsol,iters);

axH(3) = nexttile(tH,5);
lh(4) = line(Bsol,error);


xlims = [0 2];
linkaxes(axH,'x')
axH(1).XLim = xlims;
% axH.YLim = ylims;
axSetup();

%% numeric
% start value
[~,indsv] = min(abs(anaR.angB - B0));
datatip(lH(3),'DataIndex',indsv);
% calculated value
if isa(B, 'sym')
    B = double(B(1));
end
[~,indcv] = min(abs(anaR.angB - B));
datatip(lH(3),'DataIndex',indcv);