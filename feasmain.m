mat.od = [10,10];          % material outer dimensions [x,y]
mat.vertices = rectangleVert(mat.od,'lowerleft');
mat.pgon = polyshape(mat.vertices);

blade.od = [1,1];       % blade outer dimensions [x,y]
blade.vertices = rectangleVert(blade.od,'center');
% blade.pos = [5,]

face.Color = [0 0.447 0.741];
face.alpha = 0.35;
% plotting
patch(mat.pgon)
grid on;