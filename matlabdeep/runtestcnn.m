
clear all

testtestcnn=1;
filtersize1 = 5;
filtersize2 = 5;
features1 = 16;
features2 = 16;
densesize = 64;
classes = 10;
cnn_specs = [filtersize1,filtersize2,features1,features2,densesize];

batchsize = 50; % was 64
useadam=1;
epochs = 5;
dropout = 0.4;
gpumode=[0,1];
gpumode = 0;
for KK=1:length(gpumode)
    if gpumode(KK)
        deftype = DeepOp.setgetDefaultType(gpuArray(single(0)));
    else
        deftype = DeepOp.setgetDefaultType(single(0));
    end
    testcnn
    r = [];
    r.training_time = training_time;
    r.testing_time = testing_time;
    r.total_params = total_params;
    r.accuracy = accuracy;
    r.type = 'single';
    r.test = 'cnn';
    r.implementation = 'matlab';
    r.gpu = gpumode(KK);
    r.epochs = epochs;
    r.batchsize = batchsize;
    r.use_adam = useadam;
    if useadam
        r.adam_rate = adam_rate;
    else
        r.gradient_rate = gradient_rate;
    end
    r.cnn_specs = cnn_specs;
    r.iterations = iterations;
    r.cm_accuracy = mean(stats.accuracy);
    r.cm_Fscore = mean(stats.Fscore);
    stats_add(r,struct('loss',gather(losshistory),'cm',stats.confusionMat));
end

