function [vecH] = quiver3simple(origin,direction,varargin)
%QUIVER3SIMPLE simple syntax for 3x1 vectors into quiver3


% parse inputs:
vecH = quiver3(origin(1),origin(2),origin(3),...
                direction(1),direction(2),direction(3),...
                varargin{:});
end

