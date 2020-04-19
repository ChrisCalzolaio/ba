numfigs = 2;

figH = findobj('type','figure');
if numel(figH)==numfigs
    figH = figH(fliplr(1:numfigs));
    set(0,'CurrentFigure',figH);clf;
else
    for fig=1:numfigs
        figH(fig) = figure();
        drawnow();
    end
end
for fig=1:numel(figH)
    figH(fig).WindowStyle = 'docked';
end

ptCloud = [];

for step=1:numel(part)
    fprintf(1,'[ %s ] reading results of step % i\n',datestr(now,'HH:mm:SS'),step)
    ptCloud = [ptCloud;repmat(part(step).pos(3),length(part(step).pgon.Vertices),1), part(step).pgon.Vertices];
end
set(0,'CurrentFigure',figH(1))
pcshow(ptCloud);
drawnow();

aShp = alphaShape(ptCloud);
set(0,'CurrentFigure',figH(2))
pltH = plot(aShp)
line(ptCloud(:,1),ptCloud(:,2),ptCloud(:,3),'LineStyle','none','Marker','.','Color','r')
drawnow();