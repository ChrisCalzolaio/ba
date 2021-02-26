fp = "D:\temp\ptcExports";  % file system path
ftype = ".ply";             % parafoam knows ply, alternative: pcd
fn = strcat(datestr(now,'yymmdd-HHMMSS'),'_pt',ftype);

pc = pointCloud(vert,'Intensity',ones(length(vert),1));

pcwrite(pc,fullfile(fp,fn),'Encoding','ascii');