figH = getFigH(3);

% square rectangle, simplest form
vert1 = rectangleVert(1);
set(0,'CurrentFigure',figH(1));
plot(polyshape(vert1'));
grid on; grid minor; axis equal;
vert1 = rectangleVert(1,'loop','tight');

% % square rectangle, coordinate system in the center, no extra vertices
vert2 = rectangleVert(1,'coordinateSystem','center','density',0);
% % different spelling
vert3 = rectangleVert(1,'coordinateSystem','centre','density',0);
% different spelling
vert3 = rectangleVert(1,'coordinateSystem','c','density',0);
set(0,'CurrentFigure',figH(1)); hold on;
plot(polyshape(vert3'),'FaceColor','g','EdgeColor','g');

% square rectangle, force coordinate system to lower left
vert4 = rectangleVert(1,'coordinateSystem','lowerleft','density',0);
% different spelling
vert4 = rectangleVert(1,'coordinateSystem','ll','density',0);

% non-square rectangle
vert5 = rectangleVert([1,2]);
set(0,'CurrentFigure',figH(2));
plot(polyshape(vert5'))
grid on; grid minor; axis equal;

% higher density shapes
vert6 = rectangleVert([1,2],'coordinateSystem','c','density',9);
set(0,'CurrentFigure',figH(3));
pgon1 = polyshape(vert6','Simplify',false);
plot(pgon1);
grid on; grid minor; axis equal;
line(vert6(1,:),vert6(2,:),'LineStyle','none','Marker','.','Color','r')
% with closed paramter set
vert6 = rectangleVert([1,2],'coordinateSystem','c','density',9,'loop','tight');
pgon2 = polyshape(vert6','Simplify',false);

