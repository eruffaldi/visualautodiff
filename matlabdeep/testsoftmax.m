  x = Placeholder('float',[-1, 784]);
  W = Variable(zeros([784, 10]));
  b = Variable(zeros([10,1]));
  y = AddOp(MatmulOp(x,W),b);
  y_ = Placeholder('float',[-1,10]);

  %Plain:
  %   ReduceMeanOp(-ReduceSumOp(y_ * LogOp(SoftMaxOp(y)),1)
  %Optimized:
  % A 1-D Tensor of length batch_size of the same type as logits with the softmax cross entropy loss.
  cross_entropy = ReduceMeanOp(softmax_cross_entropy_with_logits(y_,y));
  train_step = GradientDescentOptimizer(0.5,cross_entropy);
  
  % batches of 100
