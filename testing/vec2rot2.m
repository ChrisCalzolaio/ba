function [R] = vec2rot(a,b)
%VEC2ROT Rotational transform matrix from basis and projected vector
%   probably doesn't work
%   source: https://math.stackexchange.com/questions/180418
%   since the function relies on trig functions, the numerical accuracy is
%   not very good

% a = a/norm(a);
% b = b/norm(b);
dim = length(a);

x = cross(a,b)/norm(cross(a,b));
theta = vecangle(a,b);

R = eye(dim) + sin(theta)*skew(x) + (1 - cos(theta))*skew(x)^2;

% if the vectors the function is given are row vectors, we need to return
% the transformation matrix as type of row
if isrow(a)
    R = R';
end
    function skw = skew(A)
        skw = [0 -A(3) A(2);...
               A(3) 0 -A(1);...
               -A(2) A(1) 0];
    end
end