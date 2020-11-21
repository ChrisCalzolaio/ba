function v = circle(r,nPt,a,b)
%CIRCLE Summary of this function goes here
%   Detailed explanation goes here
t = linspace(0,2*pi,nPt);
v(1,:) = a + r * cos(t);
v(2,:) = b + r * sin(t);

end

