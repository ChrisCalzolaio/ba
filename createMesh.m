aShp = alphaShape(ptCloud(top,1),ptCloud(top,2));
 set(0,'CurrentFigure',figH(3))
 aPlt = triplot(aShp.alphaTriangulation,aShp.Points);