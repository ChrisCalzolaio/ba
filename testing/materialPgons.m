rWst = 36;
nmPt = 1e2;
nmHt = 10;
offset = [0,0];
cver = circle(rWst,nmPt,offset);
pgon = polyshape(cver');

matpgon = repmat(pgon,nmHt,1);