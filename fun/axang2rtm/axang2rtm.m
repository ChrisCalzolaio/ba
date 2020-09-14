function R = axang2rtm( ax, ang, varargin )
%AXANG2ROTM Convert axis-angle rotation representation to rotation matrix
%   R = AXANG2ROTM(AXANG) converts a 3D rotation given in axis-angle form,
%   AXANG, to an orthonormal rotation matrix
%   ax is an N-by-1 vector of N angles
%   ang is an M-by-3 matrix of M axes
%   R is are L rotation matrices, 4x4xL by default; 3x3xL if requested
%   Each rotation matrix is orthonormal, L is determined by max(N,M)
%   N and M have to be equal, or either one has to be 1
%
%   Example:
%      % Convert a rotation from axis-angle to rotation matrix
%      ax = [0 1 0];
%      ang = [pi/2];
%      R = axang2rotm(ax,ang)
%
%   See also rotm2axang, axang2rotm
%
%   Copyright 2014-2018 The MathWorks, Inc.
%   edited 2020 - Christopher Schuster [christopher.schuster@stud.th-deg.de]

% explanation of the relevant math
% For a single axis-angle vector [ax ay az theta] the output rotation
% matrix R can be computed as follows:
% R =  [t*x*x + c	  t*x*y - z*s	   t*x*z + y*s
%       t*x*y + z*s	  t*y*y + c	       t*y*z - x*s
%       t*x*z - y*s	  t*y*z + x*s	   t*z*z + c]
% where,
% c = cos(theta)
% s = sin(theta)
% t = 1 - c
% x = normalized axis ax coordinate
% y = normalized axis ay coordinate
% z = normalized axis az coordinate

%% parse inputs
numAng = size(ang,1);                           % number of angles provided
check = true;
while check                                     % number of axes provided
    check = false;
    switch class(ax)
        case 'char'
            numAx = size(ax,2);
            axSC = true;                        % axis argument is shortcut notation
        case 'string'
            ax = char(ax);
            check = true;                          % run again
        case {'double','single','sym'}          % this doesn't contain all allowed classes (numeric, sym)
            numAx = size(ax,1);
            axSC = false;
    end
end
% check mismatch of dimensions
numInputs = max(numAx,numAng);          % assume they are equal
if ne(numAng,numAx)     % dimensions not equal
    if ~any([numAx,numAng]==1)
        % if dimensions aren't equal and none is 1, we don't know how to
        % reconcile the dimension mismatch
        error("Dimensions don't agree.")
    elseif all([numAx,numAng]==1)   % both dimensions are 1
        numInputs = 1;
    else % dimensions not equal and not both 1, we need to find the input we have to replicate
        if min(numAx,numAng) == numAx  % number of axes provided to small
            if axSC                     % when axis information was passed as char, concatenate horizontally
                ax = repmat(ax,1,numInputs);
            else                        % when axis information was passed as numeric or sym, concatenate vertically
                ax = repmat(ax,numInputs,1);
            end
        else                           % number of angles to small
            ang = repmat(ang,numInputs,1);
        end
    end
end
% parse varargin
defaultDim = '4';
expectedDim = {'4','4d','3','3d'};
p = inputParser;
validDim = @(s) any(validatestring(s,expectedDim));
addParameter(p,'dimension',defaultDim,validDim);
parse(p,varargin{:});

%% Parse axis argument
if isnumeric(ax)
    ax = ax/norm(ax);           % Normalize the axis, "stolen" from the vec2rot function
else
    axArg = ax;
    ax = zeros(numInputs,3);
    for dim=1:numInputs
        switch axArg(dim)
            case 'x'
                ax(dim,:) = [1,0,0];
            case 'y'
                ax(dim,:) = [0,1,0];
            case 'z'
                ax(dim,:) = [0,0,1];
        end
    end
end
            
% Extract the rotation angles and shape them in depth dimension
theta = zeros(1,1,numInputs,'like',ang);
theta(1,1,:) = ang;

% Compute rotation matrices
cth = cos(theta);
sth = sin(theta);
vth = (1 - cth);

% Preallocate input vectors
vx = zeros(1,1,numInputs,'like',ax);
vy = vx;
vz = vx;

% Shape input vectors in depth dimension
vx(1,1,:) = ax(:,1);
vy(1,1,:) = ax(:,2);
vz(1,1,:) = ax(:,3);

% Explicitly specify concatenation dimension
tempR = cat(1, vx.*vx.*vth+cth,     vy.*vx.*vth-vz.*sth, vz.*vx.*vth+vy.*sth, ...
               vx.*vy.*vth+vz.*sth, vy.*vy.*vth+cth,     vz.*vy.*vth-vx.*sth, ...
               vx.*vz.*vth-vy.*sth, vy.*vz.*vth+vx.*sth, vz.*vz.*vth+cth);

R = reshape(tempR, [3, 3, length(vx)]);
R = permute(R, [2 1 3]);

% return converted 4d matrix
switch p.Results.dimension
    case {'4','4d'}
        R = dim4(R,2,'forward');
end
end
