function scrollPlot(axH,lH,x)
%SCROLLPLOT Summary of this function goes here
%   Detailed explanation goes here

xlims = axH.UserData.xlims;
scroll = axH.UserData.scroll;
axH.XLim = max([xlims; x+scroll]);

for n = 1:numel(lH)
    zInt = lH(n).UserData.zInt;
    addpoints(lH(n),axH.XLim,[zInt zInt]);
end

drawnow limitrate
end

