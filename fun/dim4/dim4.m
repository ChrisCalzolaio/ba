function [A] = dim4(A,type,direction)
%DIM4 Returns 4-dimensional version of 3 dimensional vectors or transform
%matrices
% Type:
%       - vector or matrix of vectors: type 1
%       - transformation matrix: type 2
% Direction:
%       - forward: transform from 3d to 4d
%       - backward: tranform from 4d to 3d
% ToDo:
%       - better handling of edge cases required
%       - increase dimension by one, regardless of dimensions provided to
%       allow for i.e. 2d transformations
%   See also rotm2tform

sA = sizeSym(A);        % size detection must be sym robust

switch type
    case 1  % vector of coordinates
        switch direction
            case 'forward'
                % append as many rows of value one, as needed to reach 4xN
                % size, required for homogeneous transformation
                A = [A;ones([4-sA(1),sA(2:3)])];
            case 'backward'
                A = A(1:3,:,:);
        end
    case 2  % transformation matrix
        if diff(sA(1:2))            % check size conformity
            error('Provided transform matrix is not sqare.')
        end
        switch direction
            case 'forward'
                if sA(1) < 4            % only convert if matrix isn't already 4d
                    tmp = repmat(eye(4,'like',A),1,1,sA(3));
                    tmp(1:3,1:3,:) = A;
                    A = tmp;
                end
            case 'backward'
                A = A(1:3,1:3);
        end
end
end