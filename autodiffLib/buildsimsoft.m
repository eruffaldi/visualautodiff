modelname ='mnist_softmax_adam_whole';
load_system(modelname);
set_system_codemode(modelname,1); % not relevant
set_param(modelname,'SimulationMode','external')
rtwbuild(modelname)

% TODO: specify toolchain and Faster Runs

%%
set_param(modelname,'SimulationCommand','connect')
set_param(modelname,'SimulationCommand','start')

%set_param(modelname,'SimulationCommand','stop')

%%
