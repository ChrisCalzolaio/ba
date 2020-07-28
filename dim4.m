function [A] = dim4(A,type)
%DIM4 Returns 4-dimensional version of 3 dimensional vectors or transform
%matrices
% better handling of edge cases required

switch type
    case 1                      % one dimensioal, vectors
        ncols = size(A,2);      % number of column vectors in the matrix of vectors
        A = [A;ones(1,ncols)];
    case 2                      % two dimensional, (transform) matrics
        [nrows,ncols] = size(A);
        if ~(nrows==ncols)      % check size conformity
            error('Provided transform matrix is not sqare.')
        end
        tmp = eye(4);
        tmp(1:3,1:3) = A;
        A = tmp;
end
end

