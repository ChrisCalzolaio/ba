recfull = true;
rotation = 'full';
framerate = 30;
duration = 10;
frames = framerate * duration;
figH = getFigH(1);

switch rotation
    case 'full'
        angle = 360;
end

pcH = pcshow(ptCloud);
axH = gca;
axis vis3d; % freezes PlotBoxAspectRatio and DataAspectRatio by setting them to manual and the ratios to [1 1 1]

if recfull
    figH.WindowStyle = 'modal';
    figH.WindowState = 'fullscreen';
else
    figH.WindowStyle = 'docked';
end

% define equation for camera azimuth movement
% we use a upside down parabula normalized within a range of 1
% this allows scaling of output values by a simple prefactor
pos = .5;
x = linspace(0,1,frames);
y = -((1/pos)^2)*(x-pos).^2 + 1;

[az,el] = view();
for frame=0:frames
% view(az+frame*(angle/frames),el);
camorbit(angle/frames,0,'data')
fprintf('campos x=%.1f y=%.1f z=%.1f with PlotBoxAspRat %.3f %.3f %.3f and DataAspRat %.3f %.3f %.3f\n',axH.CameraPosition,axH.PlotBoxAspectRatio,axH.DataAspectRatio)
drawnow();
end

if recfull
    figH.WindowState = 'normal';
    figH.WindowStyle = 'docked';
end