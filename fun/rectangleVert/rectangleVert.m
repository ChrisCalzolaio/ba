function [vertices] = rectangleVert(varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%  Arguments:
%   - extension: array of spatial exten. of the rectangle: [x,y]
%   - coordinateSystem: position of the vertices with respect to the local coordinate system
%   - density: number of points on a line between any two neighbouring vertices
% ToDo:
%   - abfangen Dimension des Ausdehnungsarrays (Matrix oder Vektor)
%   - Erkennen der Dimension des Körpers (2D oder 3D);
%   - Vorsehen eines eignen Koordinatensystems, ausgabe der vertices in
%   abhängigkeit davon -> so funktioniert es ja effektiv schon. Die
%   verschiebung der Vertices innnerhalb des globalen Koordsys ist an der
%   Steller hier wahrscheinlich nicht sinnvoll
%   - implementieren von varargin mit sinnvollen default werten

% defaults
defaultCSYS = 'lowerleft';
expectedCSYS = {'center','centre','c','lowerleft','ll'};
defaultDensity = 0;
% parse inputs
p = inputParser;
% extension needs to be numeric, a vector and all elements need to be larger than 0
validExtension = @(x) isnumeric(x) && isvector(x) && all(x > 0);
validDensity = @(d) isnumeric(d) && isscalar(d);
addRequired(p,'extension',validExtension);
addParameter(p,'coordinateSystem',defaultCSYS,@(s) any(validatestring(s,expectedCSYS)))
addParameter(p,'density',defaultDensity,validDensity);
parse(p,varargin{:});

% "parse" extension
extension = p.Results.extension;
if isscalar(extension)
    % when the extension we are given is a scalar, the shape of the rectangle
    % vertices returned is square
    extension(2) = extension;
elseif isvector(extension)
    % when the extensions we are given is a vector, only the use the first
    % two elements, the function is limited to 2d
    extension = extension(1:2);
end
% "parse" coordinate system behaviour
coordOffs = eye(3);     % transformation matrix
switch p.Results.coordinateSystem
    case {'lowerleft','ll'}
        % do nothing
    case {'center','centre','c'}
        coordOffs(end,1:2) = -(extension./2);
end
% "parse" density parameter
density = p.Results.density + 2;

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

