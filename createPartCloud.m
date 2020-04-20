numfigs = 3;

figHtemp = findobj('type','figure');
if logical(numel(figHtemp))
    map = [];
    for fig=1:numel(figHtemp)
        map = [map;fig figHtemp(fig).Number];
    end
    [~,map] = sort(map(:,2),'descend');
    for fig=1:numel(figHtemp)
        figH(fig) = figHtemp(map(fig));
        set(0,'CurrentFigure',figH(fig));clf;
    end
    for fig=fig:numfigs-numel(figHtemp)
        figH(fig+1) = figure();
        drawnow
    end
    delete(figHtemp(numfigs+1:end))
    clearvars figHtemp map
else
    for fig=1:numfigs
        figH(fig) = figure();
        drawnow();
    end
end
for fig=1:numel(figH)
    figH(fig).WindowStyle = 'docked';
end
clearvars fig numfigs

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

 aShp = alphaShape(ptCloud(top,1),ptCloud(top,2));
 set(0,'CurrentFigure',figH(3))
 aPlt = triplot(aShp.alphaTriangulation,aShp.Points);