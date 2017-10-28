codemodes = {0,1};
runmodes = {'normal','accelerator'};

modelname ='mnist_softmax_adam_whole';
for I=1:length(codemodes)
    for J=1:length(runmodes)
        codemode = codemodes{I};
        runmode = runmodes{J};
        set_system_codemode(gcs,codemode);
        set_param(modelname,'SimulationMode',runmode)
        
        simout = sim(modelname);

        r = [];
        r.accuracy = accuracy.Data(end);
        r.training_time = realtout1.Data(end)-realtout1.Data(1);
        r.block_codegen = codemode;
        r.simulation_mode = runmode;
        
        %r.test_time = test_time;
        %r.totalparams = totalparams;
        r.implementation = 'simulink';
        %r.cm_accuracy =mean(stats.accuracy);
        %r.cm_F1 =mean(stats.Fscore);
        r.type = 'single';
        r.test = 'softmax';
        r.gpu = 0;
        r.machine = 'macos';
        hws = get_param(modelname,'modelworkspace');
        r.epochs = eval(get_param([modelname,'/','Train Test Manager'],'epochs'));
        r.batchsize = hws.getVariable('BatchSize');

        stats_add(r);
    end
end

