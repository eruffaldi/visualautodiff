
filtersize1 = 5;
filtersize2 = 5;
features1 = 16;
features2 = 16;
densesize = 128;
classes = 10;
batchsize = 128;

weight_variable = @(name,shape) Variable(name,truncated_normal_gen(shape,0,0.1,'float'));
bias_variable = @(name,shape) Variable(name,0.1*mones(shape));
max_pool_2x2 =@(x) MaxPoolOp(x,[1, 2, 2, 1],[1, 2, 2, 1],'SAME'); 
conv2d = @(x,W) Conv2dOp(x,W,[1, 1, 1, 1],'SAME');

x = Placeholder('float',[-1,784]);
y_ = Placeholder('float',[-1,classes]);

x_image = ReshapeOp(x, [-1, 28, 28, 1]);

W_conv1 = weight_variable('W_conv1',[filtersize1, filtersize1, 1, features1]);
b_conv1 = bias_variable('b_conv1',[features1]);
h_conv1 = ReluOp(AddOp(conv2d(x_image, W_conv1),b_conv1));
h_pool1 = max_pool_2x2(h_conv1);

W_conv2 = weight_variable('W_conv2',[filtersize2, filtersize2, features1, features2]);
b_conv2 = bias_variable('b_conv2',[features2]);
h_conv2 = ReluOp(AddOp(conv2d(h_pool1, W_conv2),b_conv2));
h_pool2 = max_pool_2x2(h_conv2);
W_fc1 = weight_variable('W_fc1',[7 * 7 * features2, densesize]);
b_fc1 = bias_variable('b_fc1',[densesize]);
h_pool2_flat = ReshapeOp(h_pool2, [-1, 7*7*features2]);
h_fc1 = ReluOp(AddOp(MatmulOp(h_pool2_flat, W_fc1),b_fc1));

keep_prob = Placeholder('keep_prob',1);
h_fc1_drop = DropoutOp(h_fc1, keep_prob);
W_fc2 = weight_variable('W_fc2',[densesize, classes]);
b_fc2 = bias_variable('b_fc2',[classes]);
y_conv = AddOp(MatmulOp(h_fc1_drop, W_fc2),b_fc2);

% TODO fix softmax_cross_entropy_with_logits
cross_entropy = ReduceMeanOp(softmax_cross_entropy_with_logits(y_,y_conv),0);
train_step = AdamOptimizer(1e-4,cross_entropy);

train_step.evalshapewith({x,zeros(batchsize,784),y_,zeros(batchsize,classes),keep_prob, 0.5});

%strain_step.evalwith({x,zeros(batchsize,784),y_,zeros(batchsize,classes),keep_prob, 0.5});

%%
correct_prediction = EqualOp(ArgmaxOp(y_conv, 2), ArgmaxOp(y_, 2));
accuracy = ReduceMeanOp(correct_prediction,0); 

train_accuracy = accuracy.evalwith({x,zeros(batchsize,784),y_,zeros(batchsize,classes),keep_prob, 1.0});

%test_accuracy = accuracy.evalwith({x,xtest,y_,ytest,keep_prob, 1.0});

