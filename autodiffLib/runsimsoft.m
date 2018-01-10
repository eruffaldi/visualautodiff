clear all
codemodes = {0,1};
%runmodes = {'normal','accelerator'};
runmodes = {'accelerator','accelerator'};
modelname ='mnist_softmax_adam_whole';
ids = {'C6','C7'};
load_system(modelname);


for I=1:length(ids)
    for R=1:10
        codemode = codemodes{I};
        runmode = runmodes{I};
        changed =set_system_codemode(modelname,codemode);
        set_param(modelname,'SimulationMode',runmode)
        
        simout = sim(modelname);

        r = [];
        r.accuracy = simout.accuracy.accuracy.Data(end);
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
        r.epochs = hws.getVariable('epochs');%eval(get_param([modelname,'/','Train Test Manager'],'epochs'));
        r.batchsize = hws.getVariable('batchsize');
        r.use_adam = 0;
        r.gradient_rate =  hws.getVariable('learningrate');
                istarttest = simout.predictions.Time(1);
        r.iterations = istarttest; % or -1
        r.id = ids{I};
        r.training_time = simout.realtout.Data(istarttest)-simout.realtout.Data(2);
        % +1 because of the loading spike
        r.testing_time = simout.realtout.Data(end)-simout.realtout.Data(istarttest+1);
        stats = multiclassinfo(simout.correct_predictions.Data(:),cast(simout.predictions.Data(:)-1,'like',simout.correct_predictions.Data));
        assert(length(stats.accuracy) == 10);
        r.cm_accuracy =mean(stats.accuracy);
        r.cm_Fscore =mean(stats.Fscore);
        r.cm_specificity =mean(stats.specificity);
        r.cm_sensitivity =mean(stats.sensitivity);
        r.total_params = 7850;
        stats_add(r,struct('loss',simout.loss.Data(1:istarttest),'cm',stats.confusionMat));

        end
end

