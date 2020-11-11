%% graphics
[figH,axH] = getFigH(1,'WindowStyle','keep');
set(0,'CurrentFigure',figH);
cla;

lH = plot(simAngB,simCordRS);

grid on; grid minor;
legend('x','y','z');
xlims = [0 2*pi];
ylims = [-50 0];
axH.XLim = xlims;
% axH.YLim = ylims;

%% numeric
% start value
[~,indsv] = min(abs(simAngB - B0));
datatip(lH(3),'DataIndex',indsv);
% calculated value
if isa(B, 'sym')
    Bsol = double(Bsol(1));
end
[~,indcv] = min(abs(simAngB-Bsol));
datatip(lH(3),'DataIndex',indcv);
fprintf('Value of z coordinate at %.3f rad is %.3f mm.\n',B0,simCordRS(3,indsv));