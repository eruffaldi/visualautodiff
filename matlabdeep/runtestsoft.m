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
r.totalparams = totalparams;
r.accuracy = accuracy;
r.type = 'gpusingle';
r.test = 'softmax';
r2=r;

deftype = DeepOp.setgetDefaultType(single(0));
testsoftmax
r = [];
r.training_time = training_time;
r.totalparams = totalparams;
r.accuracy = accuracy;
r.type = 'single';
r.test = 'softmax';
r1=r;

r1
r2