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

switch type
    case 1
        [nrows,ncols] = size(A);      % number of column vectors in the matrix of vectors
        switch direction
            case 'forward'
                if nrows==2             % if the vector has two rows, its only x,y, add z-value of value 0
                    A = [A;ones(1,ncols)];
                end
                A = [A;ones(1,ncols)];
            case 'backward'
                A = A(1:3,:);
        end
    case 2
        [nrows,ncols] = size(A);
        if ~(nrows==ncols)      % check size conformity
            error('Provided transform matrix is not sqare.')
        else
            sA = nrows;
        end
        switch direction
            case 'forward'
                if ~(sA == 4)           % only convert if matrix isn't already 4d
                    tmp = eye(4,'like',A);
                    tmp(1:3,1:3) = A;
                    A = tmp;
                end
            case 'backward'
                A = A(1:3,1:3);
        end
end
end