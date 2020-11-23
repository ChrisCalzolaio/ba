function v = circle(r,nPt,ofs)
%CIRCLE Summary of this function goes here
%   Detailed explanation goes here
t = linspace(0,2*pi,nPt);
v(1,:) = ofs(1) + r * cos(t);
v(2,:) = ofs(2) + r * sin(t);

end

