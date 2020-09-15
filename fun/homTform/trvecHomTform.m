function H = trvecHomTform( varargin )
%TRVECHOMTFORM Convert translation vector to homogeneous transformation
%   H = trvecHomTform( t ) converts the cartesian representation of a 3D translation
%   vector, t, into the corresponding homogeneous transformation, H.
%
%   H = trvecHomTform( 'x',a, 'y',b, 'z',c ) converts the axis-wise specified,
%   seperate values into the corresponding homogeneous transformation, H.
%   Axes along which the translation is zero, may be left out as arguments.
%
%   The function accepts inputs of type sym.
%
%   See also trvec2tform

%   Detailed explanation goes here
%   trvec = [a b c; d e f]
%   ToDo:
%       - add support for specifying translation axis by using a char
%       argument for axis (i.e.: 'x')

nArgs = length(varargin);
if nArgs == 1
    trvec = varargin{1};
elseif ~mod(nArgs,2)            % we need a Name-Value-Pair, otherwise the input is incomplete
    [xtrvec, ytrvec, ztrvec] = deal(0);
    for inpt=1:2:nArgs-1
        curVal = varargin{inpt+1};
        switch varargin{inpt}
            case 'x'
                xtrvec = curVal;
            case 'y'
                ytrvec = curVal;
            case 'z'
                ztrvec = curVal;
        end
    end
    trvec = [xtrvec, ytrvec, ztrvec];
else
    error("Incorrect number of inputs.")
end

numTransl = size(trvec,1);       % [number of Translation vectors, size of matrix of vecs]

H = repmat(eye(4,'like',trvec),[1,1,numTransl]);        % create empty identity of same type as input transformation vector
H(1:3,4,:) = trvec.';
end

