%%
addpath ../logreg_mnist
%%
x = Placeholder('float',[-1, 784]);
  W = Variable(zeros([784, 10]));
  b = Variable(zeros([10,1]));
  y = AddOp(MatmulOp(x,W),b);
  %y = AddOp(y,b); % for testing unique variable selection
  y_ = Placeholder('float',[-1,10]);

  %Plain:
  %   ReduceMeanOp(-ReduceSumOp(y_ * LogOp(SoftMaxOp(y)),1)
  %Optimized:0
  % A 1-D Tensor of length batch_size of the same type as logits with the softmax cross entropy loss.
  %cross_entropy = ReduceMeanOp(softmax_cross_entropy_with_logits(y_,y));
  cross_entropy = -ReduceMeanOp(MatmulwiseOp(y,LogOp(y_)), 1);
  train_step = GradientDescentOptimizer(0.5,cross_entropy);
   train_step.variables
   
%%
mtr = MnistBatcher("train");
mte = MnistBatcher("test");
train_step.reset();
for I=1:1000
    [batch_xs,batch_ys] = mb.next(100);
    train_step.evalwith({x,batch_xs,y_,batch_ys});
end

correct_prediction = EqualOp(ArgmaxOp(y, 1), ArgmaxOp(y_, 1));
accuracy = ReduceMeanOp(correct_prediction); 

test_images,test_labels = mte.whole();
train_accuracy = accuracy.evalwith({x,test_images,y_,test_labels});
  
train_accuracy
  % batches of 100
