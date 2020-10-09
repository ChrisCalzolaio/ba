function [vecout] = applytm(vecin,TM)
%APPLYTM Apply transformation matrix
%   vec: array of cartesian colum vectors of coordinates
%   TM: transformation matrix (3x3 or 4x4)

% vector dimensions
sVec = size(vecin,1:3);
% dim 1: koordinaten der Punkte
% dim 2: punkte in einer punktewolke
% dim 3: punkte einzelner schritte einer zeitlichen entwicklung

% transformations matrix dimensions
sTM = size(TM,1:3);
% dim 1+2: tm für punkte oder punktewolke
% dim 3: tms einzelner schritte einer zeitlichen entwicklung

% check tm size for squareness and size
if diff(sTM(1:2))
    error('Transformation dimensions incorrect')
else
    switch sTM(1)     % determine type of transformation matrix provided
        case 3          % if TM is 3d, make 4d
            TM = dim4(TM,2,'forward');
    end
end

if all([sTM(3),sVec(3)] > 1) && diff([sVec(3),sTM(3)])
    error("Length of 3rd dimensions of Point and Transformation Matrix don't agree.")
end

% apply transformation
vecout = dim4(pagemtimes( TM , dim4(vecin,1,'forward')),1,'backward');
% return point cloud with one iteration (time) step
vecout = reshape(vecout,3,sVec(2)*sTM(3));

if sVec(1)==2
% if the vector matrix was size 2, so x,y information, we converted it to
% homogeneous coordinates (z-value = 1), return only the provided information
    vecout = vecout(1:2,:);
end
end

