function [vertices] = rectangleVert(extension,coordinateSystem,density)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% ToDo:
%   - abfangen Dimension des Ausdehnungsarrays (Matrix oder Vektor)
%   - Erkennen der Dimension des Körpers (2D oder 3D);
%   - Vorsehen eines eignen Koordinatensystems, ausgabe der vertices in
%   abhängigkeit davon -> so funktioniert es ja effektiv schon. Die
%   verschiebung der Vertices innnerhalb des globalen Koordsys ist an der
%   Steller hier wahrscheinlich nicht sinnvoll
%   - implementieren von varargin mit sinnvollen default werten

dim = 2;                    % dimension hart auf 2D
extension = extension(1:2); % dito
coordOffs = eye(dim+1);     % transformation matrix
switch coordinateSystem
    case 'lowerleft'
    case 'center'
        coordOffs(end,1:2) = -(extension./2);
end
xvals = linspace(0,extension(1),density)';
yvals = linspace(0,extension(2),density)';
xvals = xvals(1:end-1);
yvals = yvals(1:end-1);
density = density -1;
vertices =[xvals,zeros(density,1);...
           repmat(extension(1),density,1),yvals;...
           extension;...
           flipud(xvals),repmat(extension(2),density,1);...
           zeros(density,1), flipud(yvals)];
vert = [vertices,ones(length(vertices),1)] * coordOffs;
vertices = vert(:,1:end-1);
end

