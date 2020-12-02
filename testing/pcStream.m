player = pcplayer([0 1],[0 1],[0 1]);
tic
for n=1:1e3
     ptCloud = pointCloud(rand(1000,3,'single'));
     view(player,ptCloud);           
end
fprintf('exec took %.3f sec. %.1f fps.\n',toc,1e3/toc)