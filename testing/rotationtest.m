GG = @(A,B) [ dot(A,B) -norm(cross(A,B)) 0;...
              norm(cross(A,B)) dot(A,B)  0;...
              0              0           1];

FFi = @(A,B) [ A (B-dot(A,B)*A)/norm(B-dot(A,B)*A) cross(B,A) ];

UU = @(Fi,G) Fi*G*inv(Fi);

a=[1 4 0]';
% a=[1 0 0]';
b=[-2 5 3]';
% b=[0 1 0]';


U = UU(FFi(a,b), GG(a,b));
norm(U) % is it length-preserving?

norm(b-U*a) % does it rotate a onto b?
% U

vu = @(v) v/norm(v);
ru = @() vu(rand(3,1));

a = vu(a);
b = vu(b);
% fprintf('a:\n')
% a = ru()
% fprintf('b:\n')
% b = ru()

U = UU(FFi(a,b), GG(a,b));
fprintf('norm(U): %d\n',norm(U))

fprintf('norm(b-U*a): %d\n',norm(b-U*a))

fprintf('U:\n')
U

fprintf('U * a\n')
U * a


figH = getFigH(1);
view(3);
origin = zeros(3);
csys = ones(3);
pltCSYS(origin,csys,'Color','r')
csysrot = U * csys;
pltCSYS(origin,csysrot,'Color','g')