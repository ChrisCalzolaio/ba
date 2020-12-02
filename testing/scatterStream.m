[figH, axH] = getFigH(1);
runflag = true;
n = 0;

d = rand(1,3,'single');
scH = scatter3(axH,d(:,1),d(:,2),d(:,3));
scH.Marker = '.';

scH.XDataSource = 'd(:,1)';
scH.YDataSource = 'd(:,2)';
scH.ZDataSource = 'd(:,3)';
scH.CDataSource = 'd(:,3)';

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
     d = rand(1000,3,'single');
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