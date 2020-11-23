function v = circlePat(r,nPt,nC)
%CIRCLEPAT Summary of this function goes here
%   r: outer radius of circle pattern
%   nPt: number of vertices along each circle
%   nC: number of circles in pattern

t = linspace(0,2*pi,nPt)';
r = linspace(1,r,nC);
v(1,:) = [reshape(cos(t) * r, 1, numel(cos(t) * r)), 0];
v(2,:) = [reshape(sin(t) * r, 1, numel(sin(t) * r)), 0];
end

