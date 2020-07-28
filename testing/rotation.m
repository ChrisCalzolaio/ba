% init visual
figH = getFigH(1);
ax = axes('Parent',figH);
ax.NextPlot = 'add';
view(3); grid on; axis vis3d; ax.View = [-8.5 57];
grp = hgtransform('Parent',ax);

rotaxis = [1,0,1]';                                 % axis of rotation
origin = zeros(3);                                  % origin-coordinate system as matrix of component vectors
csys = eye(3);                                      % origin coordinate system as matrix of the vectors

polvert = rectangleVert([2,2],'center',2);          % create polygon vertices
polyg = polyshape(polvert);                         % create polyshape object
normal = [0,0,1]';                                  % polyshapes default to the xy-plane, so default normal vector is (0,0,1)
angle = vecangle(rotaxis,normal);                   % calculate angle between default normal vector an rotation axis
complaxis = cross(rotaxis,normal);                  % complementatary axis to the rotation axis
basetm = makehgtform('axisrotate',complaxis,-angle); % create the base transformation matrix, so object is perpendicular to rotation axis

plot(polyg,'Parent',grp)                            % plot shape
mobCSYS = pltCSYS(origin,csys,'Color','m','Parent',grp);
pltCSYS(origin,csys,'Color','r');                   % plot base coordinate system

tmcsys = [csys , [1,1,1]'] * basetm';                   % calculate transformed coordinate system
tmcsys = tmcsys(:,1:3);                             % lose dispensible 4th dimension
pltCSYS(origin,tmcsys,'Color','g');                 % plot transformed coordinate system
% different approach
basetm2 = vec2rot(normal,rotaxis);
tmcsys2 = csys * basetm2;
pltCSYS(origin,tmcsys2,'Color','b')

quiver3simple([0,0,0],rotaxis);                     % axis of rotation
quiver3simple([0,0,0],complaxis);                   % axis of rotation for base transform


ax.XLim = [-2 2];
% ax.YLim = ax.XLim; ax.ZLim = ax.XLim;
ax.XLabel.String = 'x'; ax.YLabel.String = 'y'; ax.ZLabel.String = 'z';

% apply base transformation:
ax.View = [4.435604837043331e+01, 1.957179526238810e+01];
stps = 100;
% basetm = makehgtform('axisrotate',complaxis,-angle);
basetm_disc = basetm^(1/stps);
for stp=1:stps
    intermat = real(basetm_disc^stp);
    grp.Matrix = intermat;                          % apply transformation matrix
    drawnow
end

tic
for ang = linspace(0,2*pi,360)
   tm = makehgtform('axisrotate',rotaxis,ang);
   grp.Matrix = tm * basetm;
   drawnow
end
toc