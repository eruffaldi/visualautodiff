% STUB TO BE COMPLETED

deftype = single(0);

genWbCNN = @(filtersize,cin,cout) deal(truncated_normal_gen([filtersize,filtersize,cin,cout],0,0.1,deftype),0.1*mones([cout],deftype));
genWb = @(shape) deal(truncated_normal_gen(shape,0,0.1,deftype),0.1*mones(shape,deftype));

scsetup1 = conv2d_setup();
sceval1 = conv2d_eval();
scgrad1 = conv2d_grad();
smsetup1 = maxpool_setup();
smeval1 = maxpool_eval();
smgrad1 = maxpool_grad();

scsetup2 = conv2d_setup();
sceval2 = conv2d_eval();
scgrad2 = conv2d_grad();
smsetup2 = maxpool_setup();
smeval2 = maxpool_eval();
smgrad2 = maxpool_grad();


[W1,b1] = genWbCNN(filtersize1,1,features1);
[W2,b2] = genWbCNN(filtersize2,features1,features2);
[Wf1,bf1] = genWb([7*7*features2,densesize]);
[Wf2,bf2] = genWb([densesize,classes]);

%TODO h_pool2_flat = ReshapeOp(h_pool2, [-1, 7*7*features2]);
%x_image = ReshapeOp(x, [-1, 28, 28, 1]);

% x = reshape
y_conv = Dropout(ReluOp(reshape(ReluOp(conv2d(ReluOp(conv2d(x,W1) + b1)),W2) + b2))*Wf1 + bf1)*Wf2+bf2

sm = meanop(softmax_cross_entropy_with_logits(y_conv,y_),0)
out = argmax_(y_conv)

keep_prob = Placeholder('keep_prob',1);
h_fc1_drop = DropoutOp(h_fc1, keep_prob);

W_fc2 = weight_variable('W_fc2',[densesize, classes]);
b_fc2 = bias_variable('b_fc2',[classes]);
y_conv = h_fc1_drop * W_fc2 + b_fc2;

% TODO fix softmax_cross_entropy_with_logits
cross_entropy = ReduceMeanOp(softmax_cross_entropy_with_logits(y_,y_conv),0);

if useadam == 0
  train_step = GradientDescentOptimizer(0.05,cross_entropy);
  else
      train_step = AdamOptimizer(1e-4,cross_entropy);
end
  
%train_step.evalshapewith({x,mzeros([batchsize,784],deftype),y_,mzeros([batchsize,classes],deftype),keep_prob, 0.5});

%cross_entropy.evalwith({x,mzeros([batchsize,784],deftype),y_,mzeros([batchsize,classes],deftype),keep_prob, 0.5});
%cross_entropy.grad(1)
correct_prediction = EqualOp(ArgmaxOp(y_conv, 2), ArgmaxOp(y_, 2));
accuracy = ReduceMeanOp(correct_prediction,0); 
