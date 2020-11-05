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
[~,indsv] = min(abs(simAngB - sv));
datatip(lH(3),'DataIndex',indsv);
% calculated value
if isa(Bsol, 'sym')
    Bsol = double(Bsol(1));
end
[~,indcv] = min(abs(simAngB-Bsol));
datatip(lH(3),'DataIndex',indcv);
fprintf('Value of z coordinate at %.3f rad is %.3f mm.\n',sv,simCordRS(3,indsv));