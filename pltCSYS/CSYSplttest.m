origin = zeros(3);
csys = eye(3);


[figH,axH] = getFigH(2,'createaxis');
% set(0,'CurrentFigure',figH(1))
line(axH(1),linspace(0,2*pi),sin(linspace(0,2*pi)))
pltCSYS(origin,csys,'Color','r','Parent',axH(1));
% set(0,'CurrentFigure',figH(2))
line(axH(2),linspace(0,2*pi),sin(linspace(0,2*pi)))

