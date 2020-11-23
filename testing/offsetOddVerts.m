zRes = 50;
nPt = 50;
z = linspace(0,50,zRes);
zind = 0:zRes;
cver = circle(20,nPt,[0,0]);      % erzeugen der Vertices der Werkstück-Polygone
orPgon = polyshape(cver','Simplify',false);              % erzeugen des Originalen Werkstückpolgons
wkst = repmat(orPgon,zRes,1);
oddind = logical(mod(zind,2));
wkst(oddind) = wkst(oddind).rotate( rad2deg( pi/(nPt) ));
vert = extractVert(wkst,z);
pcshow(vert)