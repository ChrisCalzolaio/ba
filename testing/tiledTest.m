[figH,axH] = getFigH(1,'WindowStyle','docked');
set(0,'CurrentFigure',figH);
tH = tiledlayout(figH,5,1);
axH(1) = nexttile(tH,1,[3 1]);
legend('hdfjs','hfdskjs')
axH(2) = nexttile(tH,4);
axH(3) = nexttile(tH,5);
axSetup();

x = linspace(0,2*pi);
lH(1) = gobjects(1);

lH(1) = line(axH(1),x,sin(x));

lH(3) = line(axH(3),x,exp(x));
lH(2) = line(axH(2),x,cos(x));

lH(4) = line(axH(1),x,sin(2*x));

lH(1).YData = sin(x+1);