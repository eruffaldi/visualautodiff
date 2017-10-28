addpath ../commondeep
mysetup('json');
clear all
testtestcnn=1;
filtersize1 = 5;
filtersize2 = 5;
features1 = 16;
features2 = 16;
densesize = 64;
classes = 10;
cnn_specs = [filtersize1,filtersize2,features1,features2,densesize];

batchsize = 64; % was 64
useadam=1;
epochs = 2;


deftype = DeepOp.setgetDefaultType(gpuArray(single(0)));
testcnn
r = [];
r.training_time = training_time;
r.totalparams = totalparams;
r.accuracy = accuracy;
r.type = 'gpusingle';
r.test = 'cnn';
r.implementation = 'matlab';
r.machine = 'macos';
r.gpu = 1;
r.epochs = epochs;
r.batchsize = batchsize;
r.cnn_specs = cnn_specs;
r.cm_accuracy =mean(stats.accuracy);
r.cm_F1 =mean(stats.Fscore);
stats_add(r);

%%
testtestcnn=1;
filtersize1 = 5;
filtersize2 = 5;
features1 = 16;
features2 = 16;
densesize = 64;
classes = 10;
batchsize = 64; % was 64
useadam=1;
epochs = 2;

deftype = DeepOp.setgetDefaultType((single(0)));
testcnn
r = [];
r.training_time = training_time;
r.totalparams = totalparams;
r.accuracy = accuracy;
r.implementation = 'matlab';
r.type = 'single';
r.test = 'cnn';
r.gpu = 0;
r.cnn_specs = cnn_specs;
r.machine = 'macos';
r.epochs = epochs;
r.cm_accuracy =mean(stats.accuracy);
r.cm_F1 =mean(stats.Fscore);
r.batchsize = batchsize;
stats_add(r);
