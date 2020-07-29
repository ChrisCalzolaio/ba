function [vecH] = quiver3simple(origin,direction,varargin)
%QUIVER3SIMPLE simple syntax for 3xn vectors into quiver3
% origin may be a matrix of column vectors for vectors with different
% origin, if it is 3x1, each vector uses same origin

if logical(size(direction,2) - size(origin,2))
    origin = repmat(origin,1,size(direction,2));
end

% parse inputs:
vecH = quiver3(origin(1,:),origin(2,:),origin(3,:),...
                direction(1,:),direction(2,:),direction(3,:),...
                varargin{:});
% add text at the tips of the vectors, if more than one vector is given
if logical(size(direction,2)-1)
    for vec=1:size(direction,2)
        text(direction(1,vec),direction(2,vec),direction(3,vec),num2str(vec),varargin{:});
    end
end
end

