function [vec] = applytm(vec,TM)
%APPLYTM Apply transformation matrix
%   Detailed explanation goes here

nrowsvec = size(vec,1);
sTM = size(TM);
if ~(sTM(1) == sTM(2))
    error('Transformation dimensions incorrect')
else
    sTM = sTM(1);
end
switch sTM     % determine type of transformation matrix provided
    case 3
        TM = dim4(TM,2,'forward');
end
% apply transformation
vec = dim4(TM' * dim4(vec,1,'forward'),1,'backward');
% if the vector matrix was size 2, so x,y information, we converted it to
% a generix x,y,z vector matrix, with the z-values being 0, but we only
% want to return an x,y vector matrix again
if nrowsvec==2
    vec = vec(1:2,:);
end
end

