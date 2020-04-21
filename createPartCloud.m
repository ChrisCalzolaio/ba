figH = getFigH(3,'WindowStyle','docked');

%% read results
ptCloud = [];
readtime = tic;
for step=1:numel(part)
    if ~logical(mod(step-1,10))
        fprintf(1,'[ %s ] reading results of step % i\n',datestr(now,'HH:mm:SS'),step);
    end
    ptCloud = [ptCloud;repmat(part(step).pos(3),length(part(step).pgon.Vertices),1), part(step).pgon.Vertices];
end
fprintf(1,'[ %s ] finished reading the results, took %.3f secs.\n',datestr(now,'HH:mm:SS'),toc(readtime))
clearvars readtime step

%% plotting
set(0,'CurrentFigure',figH(1))
figH(1).Name = 'Cloud before rounding';
pcH = pcshow(ptCloud);
scH = findobj('type','scatter');
top = ptCloud(:,3) == 10;                   % find all points on the top surface
topPtH(1) = line(ptCloud(top,1),ptCloud(top,2),ptCloud(top,3),'LineStyle','none','Marker','.','Color','r');
% findobj('type','datatip');
% ptCloud(dtH.DataIndex,:)
dtH = datatip(scH(1),'DataIndex',574);
ptCloud(dtH.DataIndex,:)
drawnow();

%% creating the mesh
ptCloud = round(ptCloud,5);
top = ptCloud(:,3) == 10;                   % find all points on the top surface
set(0,'CurrentFigure',figH(2))
figH(2).Name = 'Cloud after rounding';
pcH = pcshow(ptCloud);
pcH = pcH.Children;
topPtH(2) = line(ptCloud(top,1),ptCloud(top,2),ptCloud(top,3),'LineStyle','none','Marker','.','Color','r');
