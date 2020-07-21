% Using hgtransform
figure
ax = axes;
[x,y,z] = sphere(270);

% Transform object contains the surface
grp = hgtransform('Parent',ax);
s = surf(ax,x,y,z,z,'Parent',grp,...
   'EdgeColor','none');

view(3)
grid on
axis vis3d

% Apply the transform
tic
for ang = linspace(0,2*pi,360)
   tm = makehgtform('axisrotate',[1,1,1],ang);
   disp(tm)
   grp.Matrix = tm;
   drawnow
end
toc