% init visual
figH = getFigH(1);
ax = axes('Parent',figH);
ax.NextPlot = 'add';
view(3); grid on; axis vis3d; ax.View = [-8.5 57];
grp = hgtransform('Parent',ax);

rotaxis = (-1)*[1,1,1]';                                 % axis of rotation
normal = [0,0,1]';                                  % polyshapes default to the xy-plane, so default normal vector is (0,0,1)

origin = zeros(3);                                  % origin-coordinate system as matrix of component vectors
csys = eye(3);                                      % origin coordinate system as matrix of the vectors

polvert = rectangleVert([2,2],'center',2);          % create polygon vertices
polyg = polyshape(polvert);                         % create polyshape object
plot(polyg,'Parent',grp)                            % plot shape

basetm = vec2rot(normal,rotaxis);                           % create the base transformation matrix, so object is perpendicular to rotation axis
tmcsys = applytm(csys,basetm);                              % calculate transformed coordinate system

pltCSYS(origin,csys,'Color','r');                           % plot base coordinate system
mobCSYS = pltCSYS(origin,csys,'Color','m','Parent',grp);    % plot shape fix coordinate system
pltCSYS(origin,tmcsys,'Color','g');                         % plot transformed coordinate system

quiver3simple([0,0,0]',rotaxis);                     % axis of rotation

% plot setup
ax.XLim = [-2 2];
ax.XLabel.String = 'x'; ax.YLabel.String = 'y'; ax.ZLabel.String = 'z';

% apply base transformation:
ax.View = [4.435604837043331e+01, 1.957179526238810e+01];
stps = 100;
basetm_disc = real(dim4(basetm^(1/stps),2,'forward'));
allmat = repmat(nan(size(basetm_disc)),1,1,stps);
for stp=1:stps
    intermat = basetm_disc^stp;
    allmat(:,:,stp) = intermat;
    grp.Matrix = intermat;                          % apply transformation matrix
    drawnow
end

% rotate shape around normal vector
tic
for ang = linspace(0,2*pi,360)
   tm = makehgtform('axisrotate',rotaxis,ang);
   grp.Matrix = tm * basetm;
   drawnow
end
toc