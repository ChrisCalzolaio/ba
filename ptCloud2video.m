% create a struct containing al setup parameters
rd.recfull = false;
rd.outputv = false;
rd.rotation = 'full';
rd.horizMode = 'spline';
rd.framerate = 90;
rd.duration = 10;
rd.frames = rd.framerate * rd.duration;

figH = getFigH(1);

switch rd.rotation
    case 'full'
        rd.angle = 360;
end

axH = pcshow(ptCloud);
axis vis3d; % freezes PlotBoxAspectRatio and DataAspectRatio by setting them to manual and the ratios to [1 1 1]

if rd.recfull
    figH.WindowStyle = 'modal';
    figH.WindowState = 'fullscreen';
else
    figH.WindowStyle = 'docked';
end

if rd.outputv
    drawnow
    M = repmat(getframe(figH),numel(rd.frames),1);  % grab a dummy frame and preallocate RAM with it
end

% define equation for camera azimuth movement
% we use a upside down parabula normalized within a range of 1
% this allows scaling of output values by a simple prefactor
switch rd.horizMode
    case 'sin'
        pos = .5;
        x = linspace(0,1,rd.frames);
        elevang = -((1/pos)^2)*(x-pos).^2 + 1;
        clearvars x
    case 'spline'               % ToDo: find proper way to create the Bezier curve
        fixpt = [-10,0;...
            25,0;...
            ((rd.frames/2)-25), 1;...
            ((rd.frames/2)+25), 1;...
            (rd.frames-25),0;...
            rd.frames+20 , 0];
        elevang = pchip(fixpt(:,1),fixpt(:,2),1:rd.frames);
        clearvars fixpt
end

overalltime = tic;
[az,el] = view();
for frame=1:rd.frames
    frametime = tic;
    view(az+(frame-1)*(rd.angle/rd.frames),el - 20*elevang(frame));
    
    if rd.outputv
        M(frame) = getframe(figH);                                          % grab the frame
    else
        drawnow();
    end
    
    fprintf(1,'[ %s ] plotting frame %i @ Camera [Azimuth %.1f | Elevation %.1f] took %.3f sec\n',....
                    datestr(now,'HH:mm:SS'),...
                    frame,...
                    axH.View,...
                    toc(frametime));
end
fprintf(1,'[ %s ] finished plotting, took %.3f secs.\n',datestr(now,'HH:mm:SS'),toc(overalltime))
clearvars frame overalltime az el frametime elevang

if rd.recfull
    figH.WindowState = 'normal';
    figH.WindowStyle = 'docked';
end
if rd.outputv
    io.name = strcat(datestr(now,'yyyy-mm-dd_HH-MM-SS'),'_ptCloud_export');
    io.path = strcat('D:\temp\exports\',datestr(now,'yyyy-mm-dd'));
    io.ff = fullfile(io.path,io.name);
    if ~exist(io.path,'dir')                    % make directory if it doesn't exist yet
        mkdir(io.path)
    end
    
    v = VideoWriter(io.ff);
    v.FrameRate = rd.framerate;
    
    open(v)
    writeVideo(v,M)         % Write the matrix of data M to the video file.
    close(v)                % Close the file.
    clearvars M v io
end

clearvars render axH figH rd