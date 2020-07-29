function [vec] = applytm(vec,TM)
%APPLYTM Apply transformation matrix
%   Detailed explanation goes here

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
end

