% space a
aorigin = zeros(3,1);
acsys = eye(3);
a = acsys(:,3);             % orientation of space a
apgon = rectangleVert(1,'coordinateSystem','c');

% space b
b = [1,1,1]';               % orientation of space b in a

tm = vec2rot(a,b);
bcsys = applytm(eye(3),tm);
bpgon = applytm(apgon,tm);

%% plotting
figH = getFigH(1);
% coordinate systems
pltCSYS(aorigin,acsys,'Color','b')
pltCSYS(aorigin,bcsys,'Color','r')
f = 1:4;
patch('Faces',f,'Vertices',apgon','FaceColor','blue','FaceAlpha',0.5,'EdgeColor','blue')
patch('Faces',f,'Vertices',bpgon','FaceColor','red','FaceAlpha',0.5,'EdgeColor','red')