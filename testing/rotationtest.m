clc; clearvars;
%% functions
% populated skew symmetric crossproduct matrix
GG = @(A,B) [ dot(A,B) -norm(cross(A,B)) 0;...
              norm(cross(A,B)) dot(A,B)  0;...
              0              0           1];
% rodrigues formula
FFi = @(A,B) [ A (B-dot(A,B)*A)/norm(B-dot(A,B)*A) cross(B,A) ];
UU = @(Fi,G) Fi*G*inv(Fi);

vu = @(v) v/norm(v);            % function to normalize the vectors
ru = @() vu(rand(3,1));         % function to create random vectors

%% exec
a=[0 0 1]';
b=[1 1 1]';
a = vu(a);                      % normalize vectors
b = vu(b);

U = UU(FFi(a,b), GG(a,b));
disp('is it length-preserving?')
norm(U)

disp('does it rotate a onto b?')
norm(b-U*a)

U = UU(FFi(a,b), GG(a,b));
fprintf('norm(U): %d\n',norm(U))

fprintf('norm(b-U*a): %d\n',norm(b-U*a))

fprintf('U:\n')
U

fprintf('U * a\n')
c = U * a

origin = zeros(3);
csys = eye(3);

figH = getFigH(1);

% plot vectors
quH = quiver3simple(zeros(3,1),[a,b,c]);
hold on;
% plot coordinate systems
pltCSYS(origin,csys,'Color','r');
csysrot = U * csys;
pltCSYS(origin,csysrot,'Color','g');
hold off;