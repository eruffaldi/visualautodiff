clear all
codemodes = {1};
runmodes = {'normal','accelerator'};
runmodes = {'accelerator'};
modelname ='mnist_cnn_adam';
open_system(modelname);
for I=1:length(codemodes)
    for J=1:length(runmodes)
        codemode = codemodes{I};
        runmode = runmodes{J};
        set_system_codemode(gcs,codemode);
        set_param(modelname,'SimulationMode',runmode)
        
        simout = sim(modelname);
        r = [];
        r.accuracy = simout.accuracy.Data(end);
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
        istarttest = simout.predictions.Time(1);
        catch me
            istarttest = length(simout.realtout.Data);
        end
        r.iterations = istarttest; % or -1
        r.training_time = simout.realtout.Data(istarttest)-simout.realtout.Data(2);
        r.testing_time = simout.realtout.Data(end)-simout.realtout.Data(istarttest);
        try
            stats = multiclassinfo(simout.correct_predictions.Data(:),cast(simout.predictions.Data(:)-1,'like',simout.correct_predictions.Data));
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

        stats_add(r,struct('loss',simout.loss.Data(1:iterations),'cm',stats.confusionMat));
    end
end

