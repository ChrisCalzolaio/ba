% using input with type double
A = eye(3);
Ar = dim4(A,2,'forward');
fprintf('Input is of type %s, output is of type %s.\n',class(A),class(Ar))

% using an input with a more compact data type
A = eye(3,'single');
Ar = dim4(A,2,'forward');
fprintf('Input is of type %s, output is of type %s.\n',class(A),class(Ar))

% using symbolic math data type
syms C
A = eye(3)*C;
Ar = dim4(A,2,'forward');
fprintf('Input is of type %s, output is of type %s.\n',class(A),class(Ar))