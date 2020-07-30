figH = getFigH(2);

% square rectangle, simplest form
vert1 = rectangleVert(1);
set(0,'CurrentFigure',figH(1));
plot(polyshape(vert1));
grid on; grid minor; axis equal;

% square rectangle, coordinate system in the center, no extra vertices
vert2 = rectangleVert(1,'coordinateSystem','center','density',0);
% different spelling
vert3 = rectangleVert(1,'coordinateSystem','centre','density',0);
% different spelling
vert3 = rectangleVert(1,'coordinateSystem','c','density',0);

% square rectangle, force coordinate system to lower left
vert4 = rectangleVert(1,'coordinateSystem','lowerleft','density',0);
% different spelling
vert4 = rectangleVert(1,'coordinateSystem','ll','density',0);

% non-square rectangle
vert5 = rectangleVert([1,2]);
set(0,'CurrentFigure',figH(2));
plot(polyshape(vert5))
grid on; grid minor; axis equal;

