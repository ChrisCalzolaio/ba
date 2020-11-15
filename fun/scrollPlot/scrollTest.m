[figH,axH] = getFigH(1,'WindowStyle','docked');
% figH = uifigure();
% axH = axes(figH);
% axSetup();
dlgH = waitbar(0,'Running sim...','Name','Running Sim','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(dlgH,'canceling',0);

xlims = [0 2*pi];
zInt = [-.5 .5];
scroll = [-6/4*pi 2/4*pi];

axH.XLim = xlims;
axH.UserData.scroll = scroll;
axH.UserData.xlims = xlims;

valH = animatedline(axH,'LineStyle','-','Color','#A2142F'); % value plot handle
lH = animatedline(axH,'LineStyle','-','Color','#A2142F');   % limit plot handle
lH.UserData.zInt = zInt(2);

B = 0;
dB = 0.01;

while true
    B = B + dB;
    addpoints(valH,B,sin(B));
    scrollPlot(axH,lH,B)
    if getappdata(dlgH,'canceling')
        break
    end
end

delete(dlgH)