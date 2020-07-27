function [R] = vec2rot(a,b)
%VEC2ROT Rotational transform matrix from basis and projected vector
%   probably doesn't work
%   ToDo: find source for this algorithm

dim = length(a);

v = cross(a,b);
s = norm(v);
c = dot(a,b);

R = eye(dim) + skew(v) + ((1)/(1+c))*(skew(v)^2);

if isrow(a)
    R = R';
end
    function skw = skew(v)
        skw = [0 -v(3) v(2);...
               v(3) 0 -v(1);...
               -v(2) v(1) 0];
    end
end

