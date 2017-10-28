addpath ../commondeep
clear all

testtestsoft=1;
useadam=1;
batchsize = 100;
epochs = 10;
speedtest = 1;
totalparams=0;

deftype = DeepOp.setgetDefaultType(gpuArray(single(0)));
testsoftmax
r = [];
r.training_time = training_time;
r.testing_time = test_time;
r.totalparams = totalparams;
r.accuracy = accuracy;
r.implementation = 'matlab';
r.cm_accuracy =mean(stats.accuracy);
r.cm_F1 =mean(stats.Fscore);
r.type = 'single';
r.iterations = steps;
r.test = 'softmax';
r.gpu = 1;
r.machine = 'macos';
r.epochs = epochs;
r.batchsize = batchsize;

stats_add(r);

%%
deftype = DeepOp.setgetDefaultType(single(0));
testsoftmax
r = [];
r.training_time = training_time;
r.testing_time = test_time;
r.totalparams = totalparams;
r.accuracy = accuracy;
r.type = 'single';
r.gpu = 0;
r.test = 'softmax';
r.cm_accuracy =mean(stats.accuracy);
r.cm_F1 =mean(stats.Fscore);
r.machine = 'macos';
r.implementation = 'matlab';
r.epochs = epochs;
r.iterations = steps;
r.batchsize = batchsize;
stats_add(r);