x = 300;
fX_WZrad=0;

fY_WZrad = 0;
y = 0;
Y_shift = 0;

fZ_WZrad = 0;
z = 75;

[a,b,c] = deal(0);
dirFac = -1;
f_WSTrad = 2 * dirFac;
ga = 0;

A = 0;

tic
Gesamt = @(B) createGesamt;
fprintf('Running createGesamt took %.3f sec.\n',toc)