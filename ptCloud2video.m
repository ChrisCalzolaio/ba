recfull = true;
outputv = true;
rotation = 'full';
framerate = 90;
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

if outputv
    drawnow();
    M = repmat(getframe(figH),numel(part),1);  % grab a dummy frame and preallocate RAM with it
end

% define equation for camera azimuth movement
% we use a upside down parabula normalized within a range of 1
% this allows scaling of output values by a simple prefactor
horizMode = 'spline';
switch horizMode
    case 'sin'
        pos = .5;
        x = linspace(0,1,frames);
        elevang = -((1/pos)^2)*(x-pos).^2 + 1;
        clearvars x
    case 'spline'               % ToDo: find proper way to create the Bezier curve
        fixpt = [-10,0;...
            25,0;...
            ((frames/2)-25), 1;...
            ((frames/2)+25), 1;...
            (frames-25),0;...
            frames+20 , 0];
        elevang = pchip(fixpt(:,1),fixpt(:,2),1:frames);
        clearvars fixpt
end

[az,el] = view();
for frame=0:frames
    view(az+frame*(angle/frames),el - 20*( -1/pos^2 * (frame/frames - pos).^2 + 1));
    % camorbit(angle/frames,0,'data')
    fprintf('Camera Azimuth %.3f\tElevation %.3f\n',axH.View)
    drawnow();
    
    if outputv
        M(frame+1) = getframe(figH);                                          % grab the frame
    end
end

if recfull
    figH.WindowState = 'normal';
    figH.WindowStyle = 'docked';
end
if outputv
    io.name = strcat(datestr(now,'yyyy-mm-dd_HH-MM-SS'),'_ptCloud_export');
    io.path = strcat('D:\temp\exports\',datestr(now,'yyyy-mm-dd'));
    io.ff = fullfile(io.path,io.name);
    if ~exist(io.path,'dir')                    % make directory if it doesn't exist yet
        mkdir(io.path)
    end
    
    v = VideoWriter(io.ff);
    v.FrameRate = framerate;
    
    open(v)
    writeVideo(v,M)         % Write the matrix of data M to the video file.
    close(v)                % Close the file.
end