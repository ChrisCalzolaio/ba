function [sA,isSymFlag] = sizeSym(A)
%SIZESYM Sym data type robust return of array size
% Returns the size of the first three array dimensions
% The same way the internal size behaves, it returns 1 for the third
% dimension, when given a 2d vector, both for single and double and also
% sym data type.s
%   see also: size
isSymFlag = isa(A, 'sym');
if isSymFlag
    sA = size(A);
    if numel(sA)==2
        sA(3) = 1;
    end
else
    sA = size(A,1:3);
end

