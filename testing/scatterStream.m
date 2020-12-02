[figH, axH] = getFigH(1);
runflag = true;
n = 0;

[dx,dy,dz] = sepMat(rand(1,3,'single'));
scH = scatter3(axH,dx,dy,dz);
scH.Marker = '.';

scH.XDataSource = 'dx';
scH.YDataSource = 'dy';
scH.ZDataSource = 'dz';
scH.CDataSource = 'dz';

% tExH = @(~,~,v1,v2) tExecFun(v1,v2);
tH = timer;
tH.StartDelay = 0;
tH.TimerFcn = {@tExecFun,axH};
% tH.StartFcn = @(~,~) fprintf('und es geht los\n');
tH.Period = 0.001;
tH.ExecutionMode = 'fixedSpacing';
tH.BusyMode = 'drop';
tH.UserData.n = n;

tH.start;

tic
for n=1:1e3
     [dx,dy,dz] = sepMat( rand(1000,3,'single'));
     tH.UserData.n = n;
%      pause(0.01)
%      refreshdata(axH);
%      drawnow limitrate
end

fprintf('loop took %.3f sec. loops execs per sec %.1f.\n',toc,n/toc);
fprintf('timer excts: %i.\n',tH.TasksExecuted);
fprintf('fps: %.1f.\n',tH.TasksExecuted/toc);
fprintf('avg period: %.3f\n',tH.AveragePeriod);

tH.stop;

function tExecFun(src,~,axH)
refreshdata(axH);
drawnow;
n = src.UserData.n;
if n>100
    fprintf('step %i\n',n)
    src.UserData.n = 0;
end

end

function [vx,vy,vz] = sepMat(M)
    vx = M(:,1);
    vy = M(:,2);
    vz = M(:,3);
end