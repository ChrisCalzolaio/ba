function vert = extractVert(pgVec,height)

height = height(:);
% extract vertices of each polyshape as column vector of coordinates
vertxy = single(vertcat(pgVec.Vertices));
% create column vector of corresponding z coordinates
% each z coordinate is replicated as many times, as there are vertices in 
% the corresponding polygon
vertz = single(repelem(height,pgVec.numsides));
% concatenate vectors
vert = [vertxy,vertz];

end