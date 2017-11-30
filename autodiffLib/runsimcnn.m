clear all
codemodes = {0};
runmodes = {'normal','accelerator'};
runmodes = {'accelerator'};
modelname ='mnist_cnn_adam';
load_system(modelname);
for I=1:length(codemodes)
    for J=1:length(runmodes)
        codemode = codemodes{I};
        runmode = runmodes{J};
        changed=set_system_codemode(modelname,codemode)
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
        r.test = 'cnn';
        r.gpu = 0;
        hws = get_param(modelname,'modelworkspace');
        r.cnn_specs = [hws.getVariable('filtersize1'),hws.getVariable('filtersize2'),hws.getVariable('features1'),hws.getVariable('filtersize2'),hws.getVariable('densesize')];
        r.epochs = hws.getVariable('epochs');
        %eval(get_param([modelname,'/','Train Test Manager'],'epochs'));
        r.batchsize = hws.getVariable('batchsize');
        
        try
        istarttest = predictions.Time(1);
        catch me
            istarttest = length(realtout.Data);
        end
        r.iterations = istarttest; % or -1
        r.training_time = realtout.Data(istarttest)-realtout.Data(2);
        r.testing_time = realtout.Data(end)-realtout.Data(istarttest);
        r.use_adam = 1;
        r.adam_rate = 1e-4;
        try
            stats = multiclassinfo(correct_predictions.Data(:),cast(predictions.Data(:)-1,'like',correct_predictions.Data));
            assert(length(stats.accuracy) == 10);
            r.cm_accuracy =mean(stats.accuracy);
            r.cm_Fscore =mean(stats.Fscore);
            r.cm_specificity =mean(stats.specificity);
            r.cm_sensitivity =mean(stats.sensitivity);
        catch me
            stats = [];
            stats.confusionMat = [];
            r.cm_accuracy = NaN;
            r.cm_Fscore = NaN;
            r.testing_time = NaN;
        end
        r.total_params = 0;
        stats_add(r,struct('loss',loss.Data(1:r.iterations),'cm',stats.confusionMat));
    end
end

