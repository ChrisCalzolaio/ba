function v = circle(r,nPt,ofs)
%CIRCLE creates equally spaced discrete points on a circle
%   r:      radius of circle
%   nPt:    number of discrete points
%   ofs:    vector of linear offsets from coordinate system origin
t = linspace(0,2*pi,nPt);
v(1,:) = ofs(1) + r * cos(t);
v(2,:) = ofs(2) + r * sin(t);

end

