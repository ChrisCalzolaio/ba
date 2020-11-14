function eng = checkEng(p,TM,zInt,r)
%CHECKENG Summary of this function goes here
%   p: Pointcloud
%   TM: transformation matrix
%   zInt: interval of permitted z values [zmin zmax]
%   r: radius of workpiece

eng = false;
% calculate transformed points
p = applytm(p,TM);

% check for z interval
if any( min(p(3,:)) <= max(zInt), max(p(3,:)) >= min(zInt) )
    % only if that is true, do the radius calculation
    rp = vecnorm(p(1:2,:),2,1);     % euclidean norm along the colums
    if min(rp) <= r
        eng = true;
    end
end

end

