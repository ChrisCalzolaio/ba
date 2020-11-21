function [varargout] = rectangleVert(varargin)
%rectangleVert Create rectangle vertices in cartesian coordinates
%  Arguments:
%   - extension: array of spatial exten. of the rectangle: [x,y]
%   - coordinateSystem: position of the vertices with respect to the local coordinate system
%   - density: number of points on a line between any two neighbouring vertices
%   - loop: create a watertight or an open (only unique vertices) shape
%   - dimension: 2 (2D) (default) or 3 (3D) vertice information
%   Output: [vertices, connMap]
%   - vertices: 3xn array of column vectors
%   - connMap: 1xn vector of connections of the vertices array

% ToDo:
%   - abfangen Dimension des Ausdehnungsarrays (Matrix oder Vektor)
%   - Erkennen der Dimension des Körpers (2D oder 3D);
%   - Vorsehen eines eignen Koordinatensystems, ausgabe der vertices in
%   abhängigkeit davon -> so funktioniert es ja effektiv schon. Die
%   verschiebung der Vertices innnerhalb des globalen Koordsys ist an der
%   Steller hier wahrscheinlich nicht sinnvoll
%   - implementieren von varargin mit sinnvollen default werten

%% defaults
% coordinateSystem
defaultCSYS = 'lowerleft';
expectedCSYS = {'center','centre','c','lowerleft','ll'};
% Loop (tightness)
defaultLoop = 'open';
expectedLoop = {'tight','open'};
% density
defaultDensity = 0;
% dimension
defaultDim = 2;
expectedDim = [2,3];
%% parse inputs
p = inputParser;
% extension needs to be numeric, a vector and all elements need to be larger than 0
validExtension = @(x) isnumeric(x) && isvector(x) && all(x > 0);
% density need to be numeric and a scalar
validNumScal = @(d) isnumeric(d) && isscalar(d);
% dimension needs to be numeric, scalar, and within range
validDimension = @(d) validNumScal(d) && any(expectedDim == d);
% add arguments of the function to the parser
addRequired(p,'extension',validExtension);
addParameter(p,'coordinateSystem',defaultCSYS,@(s) any(validatestring(s,expectedCSYS)));
addParameter(p,'density',defaultDensity,validNumScal);
addParameter(p,'loop',defaultLoop,@(s) any(validatestring(s,expectedLoop)));
addParameter(p,'dimension',defaultDim,validDimension);
% parse
parse(p,varargin{:});

%% process
% extension
extension = p.Results.extension;
z = 0;
if isscalar(extension)
    % when the extension we are given is a scalar, the shape of the rectangle
    % vertices returned is square
    extension(2,1) = extension;
elseif isvector(extension)
    extension = extension(:);   % make sure the extension parameter is a column vector
    % when the extensions we are given is a vector, only the use the first
    % two elements, the function is limited to 2d
    if numel(extension) == 3 && p.Results.dimension == 3
        z = extension(3);
    end
    extension = extension(1:2);
end

% coordinate system
coordOffs = eye(4);     % transformation matrix
switch p.Results.coordinateSystem
    case {'lowerleft','ll'}
        % do nothing
    case {'center','centre','c'}
        coordOffs = trvecHomTform( [-extension'./2 , z] );
end

% density
density = p.Results.density + 2;

%% create vertices
xvals = linspace(0,extension(1),density);
yvals = linspace(0,extension(2),density);
xvals = xvals(1:end-1);
yvals = yvals(1:end-1);
density = density -1;
% create vertices
vertices =[[xvals;zeros(1,density)],...
           [repmat(extension(1),1,density);yvals],...
           extension,...
           [fliplr(xvals);repmat(extension(2),1,density)],...
           [zeros(1,density); fliplr(yvals)]];
vertices = [vertices;zeros(1,size(vertices,2))];
% apply transformation
vert = applytm(vertices,coordOffs);

% connectivity map
connmap = [1:(size(vertices,2)-1),1];

% apply tightness characteristic
if strcmp(p.Results.loop,'open')
    vertices = vert(:,1:end-1);
    connmap = connmap(1:end-1);
end
% remove unwanted third dimension
if p.Results.dimension == 2
    vertices = vertices(1:2,:);
end

%% return values
varargout{1} = vertices;
if nargout == 2
    varargout{2} = connmap;
end
end
