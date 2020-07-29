function [A] = dim4(A,type,direction)
%DIM4 Returns 4-dimensional version of 3 dimensional vectors or transform
%matrices
% Direction:
%       - forward: transform from 3d to 4d
%       - backward: tranform from 4d to 3d
% better handling of edge cases required

switch type
    case 1                      % one dimensioal, vectors
        ncols = size(A,2);      % number of column vectors in the matrix of vectors
        switch direction
            case 'forward'
                A = [A;ones(1,ncols)];
            case 'backward'
                A = A(1:3,:);
        end
    case 2                      % two dimensional, (transform) matrics
        [nrows,ncols] = size(A);
        if ~(nrows==ncols)      % check size conformity
            error('Provided transform matrix is not sqare.')
        end
        switch direction
            case 'forward'
                tmp = eye(4);
                tmp(1:3,1:3) = A;
                A = tmp;
            case 'backward'
                A = A(1:3,1:3);
        end
end
end

