%% setup
% simulation
sim = struct();                     % init a struct, sim is technically an inbuilt function...
sim.rotation = 90;
sim.steps = 1e3;
sim.logt = table('Size',[0,4],...
                'VariableTypes',{'uint64','double','double','double'},...
                'VariableNames',{'step','xpos','rota','step_exec_time'});        % maybe add start of execution time?
% graphical output


%% creation of objects
% the material
mat.od = [10,10,10]';                                            % [x,y,z]: material outer dimensions
mat.pos = [0,0,0]';                                              % [x,y,z]: material coordinate system position within the the global coordsys
mat.local.vertices = rectangleVert(mat.od,'coordinateSystem','lowerleft','density',100);
mat.global.vertices = mat.local.vertices + mat.pos(1:2);
mat.pgon = polyshape(mat.global.vertices','Simplify',false);
% blade, the cutting feature
blade.od =  [1,1,0]';                                             % [x,y,z]: blade outer dimensions
blade.pos = [0,mat.od(1)/2,mat.od(2)]';                          % [x,y,z]: blade coordinate system position in global coordinate system
blade.local.vertices = rectangleVert(blade.od(1:2),'coordinateSystem','center','density',10);
blade.global.vertices = blade.local.vertices + blade.pos(2:3);
blade.pgon = polyshape(blade.global.vertices','Simplify',false);

%% simulation
fprintf(1,'[ %s ] Simulation setup.\n',datestr(now,'HH:mm:SS'));
% calculate step sizes
sim.stepsize.x = mat.od(3)/sim.steps;
sim.stepsize.rot = sim.rotation/sim.steps;
% preallocation of RAM
part     = repmat(mat,  (sim.steps +1),1);                                  % the part, the result of the cutting operation
toolpath = repmat(blade,(sim.steps +1),1);

simtime = tic;
for step=1:(sim.steps + 1)
    stepdur = tic;
    xpos = (step-1) * sim.stepsize.x;
    rota = (step-1) * sim.stepsize.rot;
    toolpath(step).pgon = blade.pgon.rotate(rota,blade.pos(2:3)');

    part(step).pgon = mat.pgon.subtract(toolpath(step).pgon,'KeepCollinearPoints',true);
    part(step).pos(3) = xpos;
    
    if ~logical(mod(step-1,10))
        fprintf(1,'[ %s ] step %i @ xpos=%.3f mm and rota=%.3f° took %.4e sec.\n',...
            datestr(now,'HH:mm:SS'),...
            step,...
            xpos,...
            rota,...
            toc(stepdur));
    end
    sim.logt{step,:} = [step,xpos,rota,toc(stepdur)];
end; clearvars xpos rota stepdur step;

fprintf(1,['[ %s ] finished Simulation.\n', ...
           '\t\t\t%i steps took %.3f sec.\n', ...
           '\t\t\tsingle step cummulative time was %.3f sec.\n'],....
           datestr(now,'HH:mm:SS'),numel(part),toc(simtime),sum(sim.logt.step_exec_time));

clearvars simtime;