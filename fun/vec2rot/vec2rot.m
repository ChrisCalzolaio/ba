function [R] = vec2rot(a,b)
%VEC2ROT Rotational transform matrix from basis and projected vector
%   probably doesn't work
%   ToDo: find source for this algorithm

dim = length(a);

% normalize input vectors
a = vnorm(a);
b = vnorm(b);

v = cross(a,b);     % crossproduct
s = norm(v);
c = dot(a,b);
% rotation matrix: Rodrigues' rotation formula
R = eye(dim) + skew(v) + skew(v)^2*(1-c)/((s)^2);
R = dim4(R,2,'forward');

if isrow(a)
    R = R';
end
%% local functions
% skew symmetric crossproduct matrix
    function skw = skew(A)
        skw = [0   -A(3) A(2);...
               A(3) 0   -A(1);...
              -A(2) A(1) 0];
    end
% normalize vectors
    function v = vnorm(v)
        v = v/norm(v);
    end
end