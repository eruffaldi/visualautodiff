
weight_variable = @(shape) Variable(truncated_normal_gen(shape,0,0.1,'float'));
bias_variable = @(shape) Variable(0.1*mones(shape));
max_pool_2x2 =@(x) MaxPoolOp(x,[1, 2, 2, 1],[1, 2, 2, 1],'SAME'); 

conv2d = @(x,W) Conv2dOp(x,W,[1, 1, 1, 1],'SAME');

x = Placeholder('float',[-1,784]);
y_ = Placeholder('float',[-1,10]);

x_image = ReshapeOp(x, [-1, 28, 28, 1]);

W_conv1 = weight_variable([5, 5, 1, 32])
b_conv1 = bias_variable([32])
h_conv1 = ReluOp(AddOp(conv2d(x_image, W_conv1),b_conv1));
h_pool1 = max_pool_2x2(h_conv1);

W_conv2 = weight_variable([5, 5, 32, 64])
b_conv2 = bias_variable([64])
h_conv2 = ReluOp(AddOp(conv2d(h_pool1, W_conv2),b_conv2));
h_pool2 = max_pool_2x2(h_conv2);
W_fc1 = weight_variable([7 * 7 * 64, 1024]);
b_fc1 = bias_variable([1024]);
h_pool2_flat = ReshapeOp(h_pool2, [-1, 7*7*64]);
h_fc1 = ReluOp(AddOp(MatmulOp(h_pool2_flat, W_fc1),b_fc1));

keep_prob = Placeholder('float',1);
h_fc1_drop = DropoutOp(h_fc1, keep_prob);
W_fc2 = weight_variable([1024, 10]);
b_fc2 = bias_variable([10]);
y_conv = AddOp(MatmulOp(h_fc1_drop, W_fc2),b_fc2);


cross_entropy = ReduceMeanOp(softmax_cross_entropy_with_logits(y_,y_conv));
%  train_step = tf.train.AdamOptimizer(1e-4).minimize(cross_entropy)
%  correct prediction: f.equal(tf.argmax(y_conv, 1), tf.argmax(y_, 1))
%  accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

