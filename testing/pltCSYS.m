function [csysH] = pltCSYS(origin,drct,varargin)
%csysH = PLTCSYS(origin,direction) plots coordinate system using line

pltarray = reshape([origin(:),drct(:)]',6,3);
csysH = line(pltarray(:,1),pltarray(:,2),pltarray(:,3),varargin{:});

txts = {'x','y','z'};
for dim=1:3
	text(drct(dim,1),drct(dim,2),drct(dim,3),txts{dim},varargin{:});
end

end

