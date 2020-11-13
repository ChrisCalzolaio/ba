data = 'traj';
switch data
    case 'sim'
        load('simRes.mat');
        traj = anaR.anaCord;
        Bvec = anaR.angB;
        clearvars anaR simR
        nP = 1;
    case 'traj'
        nP = size(traj,2);
end

nP = 1;     % point selector

%% graphics
[figH,axH] = getFigH(1,'WindowStyle','keep');
set(0,'CurrentFigure',figH);
tH = tiledlayout(figH,5,1);

axH(1) = nexttile(tH,1,[3 1]);
lH(1) = line(axH,shiftdim( Bvec),shiftdim(traj(3,nP,:)),'Color','#EDB120');
lH(2) = line(shiftdim(Bsol(1,nP,:)),z_soll,'color','#A2142F','Marker','.');
legend('Z sim','Z iter');

axH(2) = nexttile(tH,4);
lH(3) = line(shiftdim(Bsol(1,nP,:)),iters);

axH(3) = nexttile(tH,5);
lh(4) = line(shiftdim(Bsol(1,nP,:)),err);


xlims = [0 2];
linkaxes(axH,'x')
% axH(1).XLim = xlims;
% axH.YLim = ylims;
axSetup();

%% numeric
% start value
[~,indsv] = min(abs(shiftdim(Bvec) - B0(nP)));
datatip(lH(3),'DataIndex',indsv);
% calculated value
if isa(B, 'sym')
    B = double(B(1));
end
[~,indcv] = min(abs(Bvec - B));
datatip(lH(3),'DataIndex',indcv);