clc; clearvars;
%% functions
% populated skew symmetric crossproduct matrix
GG = @(A,B) [ dot(A,B) -norm(cross(A,B)) 0;...
              norm(cross(A,B)) dot(A,B)  0;...
              0              0           1];
% rodrigues formula
FFi = @(A,B) [ A (B-dot(A,B)*A)/norm(B-dot(A,B)*A) cross(B,A) ];
UU = @(Fi,G) Fi*G*inv(Fi);

% computationally more efficient
% skew symmetric crossproduct matrix
ssc = @(v) [0 -v(3) v(2);...
            v(3) 0 -v(1);...
            -v(2) v(1) 0];

RU = @(A,B) eye(3) + ssc(cross(A,B)) + ssc(cross(A,B))^2*(1-dot(A,B))/(norm(cross(A,B))^2);

vu = @(v) v/norm(v);            % function to normalize the vectors
ru = @() vu(rand(3,1));         % function to create random vectors

%% exec
a=[0 0 1]';
b=[1 1 1]';
a = vu(a);                      % normalize vectors
b = vu(b);

U_old = UU(FFi(a,b), GG(a,b));
U_new = RU(a,b);
fprintf('[old] Is it length-preserving:\nnorm(U): %d\n',norm(U_old))
fprintf('[new] Is it length-preserving:\nnorm(U): %d\n',norm(U_new))

fprintf('[old] Does it rotate a onto b?\nnorm(b-U*a): %d\n',norm(b-U_old*a))
fprintf('[new] Does it rotate a onto b?\nnorm(b-U*a): %d\n',norm(b-U_new*a))

fprintf('[old] U * a\n')
c = U_old * a
fprintf('[new] U * a\n')
c = U_new * a

origin = zeros(3);
csys = eye(3);

figH = getFigH(1);

% plot vectors
quH = quiver3simple(zeros(3,1),[a,b,c]);
% hold on;
% plot coordinate systems
pltCSYS(origin,csys,'Color','r');
csysrot = csys * U_old';
pltCSYS(origin,csysrot,'Color','g');
% hold off;