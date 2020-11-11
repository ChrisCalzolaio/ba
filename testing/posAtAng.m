%% graphics
[figH,axH] = getFigH(1,'WindowStyle','keep');
set(0,'CurrentFigure',figH);

lH = plot(anaR.angB,anaR.simCord);

grid on; grid minor;
legend('x','y','z');
xlims = [0 2*pi];
ylims = [-50 0];
axH.XLim = xlims;
% axH.YLim = ylims;

%% numeric
% start value
[~,indsv] = min(abs(anaR.angB - B0));
datatip(lH(3),'DataIndex',indsv);
% calculated value
if isa(B, 'sym')
    B = double(B(1));
end
[~,indcv] = min(abs(anaR.angB - B));
datatip(lH(3),'DataIndex',indcv);
fprintf('Value of z coordinate at %.3f rad is %.3f mm.\n',B0,anaR.simCord(indsv,3));