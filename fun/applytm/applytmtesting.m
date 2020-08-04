% space a
aorigin = zeros(3,1);
acsys = eye(3);
a = acsys(:,3);             % orientation of space a
[apgon,f] = rectangleVert(1,'coordinateSystem','c','dimension',3);

% space b
b = [0,1,1]';               % orientation of space b in a

tm = vec2rot(a,b);
bcsys = applytm(acsys,tm);
bpgon = applytm(apgon,tm');

%% plotting
figH = getFigH(1);
% coordinate systems
pltCSYS(aorigin,acsys,'Color','b')
pltCSYS(aorigin,bcsys,'Color','r')
patch('Faces',f,'Vertices',apgon','FaceColor','b','FaceAlpha',0.5,'EdgeColor','b')
patch('Faces',f,'Vertices',bpgon','FaceColor','r','FaceAlpha',0.5,'EdgeColor','r')

grid on; grid minor; axis equal