
cv = circlePat(rWst,1e2,1e2)';
cvu = [cv, repmat(max(z_soll),length(cv),1)]; % upper circle
cvl = [cv, repmat(min(z_soll),length(cv),1)];

vert = [vert;cvu;cvl];

shp = alphaShape(vert,5);
plot(shp)