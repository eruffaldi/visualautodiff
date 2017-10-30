addpath ../commondeep
clear all

testtestsoft=1;
useadam=0;
batchsize = 100;
epochs = 10;
speedtest = 1;
gpumode = [0,1];
total_params = 7850;

for I=1:length(gpumode)
    if gpumode(I)
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
    r.gpu = gpumode(I);
    r.epochs = epochs;
    r.batchsize = batchsize;

    stats_add(r,struct('loss',losshistory,'cm',stats.confusionMat));
end
