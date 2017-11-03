clear all

testtestsoft=1;
useadam=0;
batchsize = 100;
epochs = 5;
speedtest = 1;
gpumode = [0,1];
total_params = 7850;

for Q=1:length(gpumode)
    if gpumode(Q)
        deftype = DeepOp.setgetDefaultType(gpuArray(single(0)));
    else
        deftype = DeepOp.setgetDefaultType(single(0));
    end
    testsoftmax
    r = [];
    r.training_time = training_time;
    r.testing_time = testing_time;
    r.total_params = total_params;
    r.accuracy = accuracy;
    r.implementation = 'matlab';
    r.cm_accuracy =mean(stats.accuracy);
    r.cm_Fscore =mean(stats.Fscore);
    r.type = 'single';
    r.iterations = steps;
    r.test = 'softmax';
    r.gpu = gpumode(Q);
    r.use_adam = useadam;
    if useadam
        r.adam_rate = adam_rate;
    else
        r.gradient_rate = gradient_rate;
    end
    r.epochs = epochs;
    r.batchsize = batchsize;

    stats_add(r,struct('loss',gather(losshistory),'cm',stats.confusionMat));
end
