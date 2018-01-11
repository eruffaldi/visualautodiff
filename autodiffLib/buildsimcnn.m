modelname ='mnist_cnn_adam';
load_system(modelname);
set_system_codemode(modelname,1); % not relevant
set_param(modelname,'SimulationMode','external')
rtwbuild(modelname)

%%
set_param(modelname,'SimulationCommand','connect')
set_param(modelname,'SimulationCommand','start')

%set_param(modelname,'SimulationCommand','stop')

%%
