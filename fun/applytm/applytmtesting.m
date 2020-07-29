% space a
aorigin = zeros(3,1);
acsys = eye(3);
a = acsys(:,3);             % orientation of space a

% space b
b = [1,1,1]';               % orientation of space b in a

tm = vec2rot(a,b);
bcsys = applytm(eye(3),tm);

%% plotting
figH = getFigH(1);
% coordinate systems
pltCSYS(aorigin,acsys,'Color','b')
pltCSYS(aorigin,csys,'Color','r')