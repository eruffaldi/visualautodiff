addpath ../commondeep

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


deftype = DeepOp.setgetDefaultType(gpuArray(single(0)));
testcnn
r = [];
r.training_time = training_time;
r.totalparams = totalparams;
r.accuracy = accuracy;
r.type = 'gpusingle';
r.test = 'cnn';
r2=r;

deftype = DeepOp.setgetDefaultType((single(0)));
testcnn
r = [];
r.training_time = training_time;
r.totalparams = totalparams;
r.accuracy = accuracy;
r.type = 'single';
r.test = 'cnn';
r1=r;

