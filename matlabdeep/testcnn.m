
filtersize1 = 5;
features1 = 32;
filtersize2 = 5;
features2 = 64;
densesize = 1024;
classes = 10;
batchsize = 128;

weight_variable = @(shape) Variable(truncated_normal_gen(shape,0,0.1,'float'));
bias_variable = @(shape) Variable(0.1*mones(shape));
max_pool_2x2 =@(x) MaxPoolOp(x,[1, 2, 2, 1],[1, 2, 2, 1],'SAME'); 
conv2d = @(x,W) Conv2dOp(x,W,[1, 1, 1, 1],'SAME');

x = Placeholder('float',[-1,784]);
y_ = Placeholder('float',[-1,classes]);

x_image = ReshapeOp(x, [-1, 28, 28, 1]);

W_conv1 = weight_variable([filtersize1, filtersize1, 1, features1]);
b_conv1 = bias_variable([features1]);
h_conv1 = ReluOp(AddOp(conv2d(x_image, W_conv1),b_conv1));
h_pool1 = max_pool_2x2(h_conv1);

W_conv2 = weight_variable([filtersize2, filtersize2, features1, features2]);
b_conv2 = bias_variable([features2]);
h_conv2 = ReluOp(AddOp(conv2d(h_pool1, W_conv2),b_conv2));
h_pool2 = max_pool_2x2(h_conv2);
W_fc1 = weight_variable([7 * 7 * features2, densesize]);
b_fc1 = bias_variable([1024]);
h_pool2_flat = ReshapeOp(h_pool2, [-1, 7*7*densesize]);
h_fc1 = ReluOp(AddOp(MatmulOp(h_pool2_flat, W_fc1),b_fc1));

keep_prob = Placeholder('float',1);
h_fc1_drop = DropoutOp(h_fc1, keep_prob);
W_fc2 = weight_variable([densesize, classes]);
b_fc2 = bias_variable([classes]);
y_conv = AddOp(MatmulOp(h_fc1_drop, W_fc2),b_fc2);

% TODO fix softmax_cross_entropy_with_logits
cross_entropy = ReduceMeanOp(softmax_cross_entropy_with_logits(y_,y_conv),0);
train_step = AdamOptimizer(1e-4,cross_entropy);

train_step.evalwith({x,zeros(batchsize,784),y_,zeros(batchsize,classes),keep_prob, 0.5});

correct_prediction = EqualOp(ArgmaxOp(y_conv, 1), ArgmaxOp(y_, 1));
accuracy = ReduceMeanOp(correct_prediction,0); 

train_accuracy = accuracy.evalwith({x,zeros(batchsize,784),y_,zeros(batchsize,classes),keep_prob, 1.0});

%test_accuracy = accuracy.evalwith({x,xtest,y_,ytest,keep_prob, 1.0});

