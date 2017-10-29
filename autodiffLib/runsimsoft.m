clear all
codemodes = {0,1};
runmodes = {'normal','accelerator'};
modelname ='mnist_softmax_adam_whole';
open_system(modelname);

for I=1:length(codemodes)
    for J=1:length(runmodes)
        codemode = codemodes{I};
        runmode = runmodes{J};
        set_system_codemode(gcs,codemode);
        set_param(modelname,'SimulationMode',runmode)
        
        simout = sim(modelname);

        r = [];
        r.accuracy = accuracy.Data(end);
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
        hws = get_param(modelname,'modelworkspace');
        r.epochs = eval(get_param([modelname,'/','Train Test Manager'],'epochs'));
        r.batchsize = hws.getVariable('BatchSize');

                istarttest = predictions.Time(1);
        r.iterations = istarttest; % or -1
        r.training_time = realtout.Data(istarttest)-realtout.Data(2);
        r.testing_time = realtout.Data(end)-realtout.Data(istarttest);
        stats = multiclassinfo(correct_predictions.Data(:),cast(predictions.Data(:)-1,'like',correct_predictions.Data));
        assert(length(stats.accuracy) == 10);
        r.cm_accuracy =mean(stats.accuracy);
        r.cm_Fscore =mean(stats.Fscore);

        stats_add(r);
    end
end

