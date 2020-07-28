function [csysH] = pltCSYS(origin,drct,varargin)
%csysH = PLTCSYS(origin,direction) plots coordinate system using line


pltarray = reshape([origin(:),drct(:)]',6,3);
csysH = line(pltarray(:,1),pltarray(:,2),pltarray(:,3),varargin{:});

txts = {'x','y','z'};
for dim=1:3
	text(drct(dim,1),drct(dim,2),drct(dim,3),txts{dim},varargin{:});
end

% detect if provided axis object is 3d
% ref: https://stackoverflow.com/questions/8064969
% modification: we look at the azimuth value, since it is only 0, if axis
% is 2d
% if axis was 3d, but the view angles were different from default, the
% shown method won't work. this is a hacky workaround...
axH = csysH.Parent;                             % we cannot use the Parent argument from varargin, since it's optional
tries = 1;
while true                                      % the parent handle of the line handle is not an axis, we try to find on up the tree
    if strcmp(get(axH,'Type'),'axes')           % if our current handle is type axis, stop searching
        break
    else
        axH = axH.Parent;                       % if not, look at parent within tree
    end
    if tries==3
        error('Error using pltCSYS.\nUnable to find a parent axis handle for the provided Figure.')
    end
end
ornt = axH.View;                                % get orientation
if ~logical(ornt(1))                            % first value is the azimuth
    % selecting the axis using set() doesn't work in this case, thanks
    % matlab, honestly wtf
    view(axH,3);
    axis(axH,'vis3d')
end

end

