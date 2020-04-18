function [vertices] = rectangleVert(extension,coordinateSystem)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% ToDo:
%   - abfangen Dimension des Ausdehnungsarrays (Matrix oder Vektor)
%   - Erkennen der Dimension des Körpers (2D oder 3D);
%   - Vorsehen eines eignen Koordinatensystems, ausgabe der vertices in
%   abhängigkeit davon
dim = 2;                    % dimension hart auf 2D
coordOffs = eye(dim+1);     % transformation matrix
switch coordinateSystem
    case 'lowerleft'
    case 'center'
        coordOffs(end,1:2) = -(extension./2);
end
vertices = [0,0;...
            extension(1), 0;...
            extension(1),extension(2);...
            0, extension(2)];
vert = [vertices,ones(length(vertices),1)] * coordOffs;
vertices = vert(:,1:end-1);
end

