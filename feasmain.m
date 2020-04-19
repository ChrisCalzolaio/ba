%% creation of objects
% the material
mat.od = [10,10];          % material outer dimensions [x,y]
mat.pos = [0,0];            % material coordinate system position
mat.local.vertices = rectangleVert(mat.od,'lowerleft');
mat.global.vertices = mat.local.vertices + mat.pos;
mat.pgon = polyshape(mat.global.vertices);
% blade, the cutting feature
blade.od = [1,1];       % blade outer dimensions [x,y]
blade.pos = [mat.od(1)/2,mat.od(2)];
blade.local.vertices = rectangleVert(blade.od,'center');
blade.global.vertices = blade.local.vertices + blade.pos;
blade.pgon = polyshape(blade.global.vertices);
% the part, the result of the cutting operation
part = mat;
part.pgon = mat.pgon.subtract(blade.pgon);

%% plotting
face.Color = [0 0.447 0.741];
face.alpha = 0.35;

figH = findobj('type','figure');
if logical(numel(figH))
    figH = figH(1);
    set(0,'CurrentFigure',figH);clf;
else
    figH = figure();
end

axH(1) = subplot(1,2,1);
patch('Faces',1:length(mat.pgon.Vertices),'Vertices',mat.pgon.Vertices,'FaceColor',face.Color,'FaceAlpha',face.alpha)
patch('Faces',[1 2 3 4],'Vertices',blade.pgon.Vertices,'FaceColor',mod(face.Color+.5,1),'FaceAlpha',face.alpha)
axH(1).DataAspectRatio = [1 1 1];
grid on; grid minor;

axH(2) = subplot(1,2,2);
patch('Faces',1:length(part.pgon.Vertices),'Vertices',part.pgon.Vertices,'FaceColor',face.Color,'FaceAlpha',face.alpha)
axH(2).DataAspectRatio = [1 1 1];
grid on; grid minor;