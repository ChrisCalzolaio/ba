player = pcplayer([0 1],[0 1],[0 1]);
while isOpen(player) 
     ptCloud = pointCloud(rand(1000,3,'single'));
     view(player,ptCloud);           
end 