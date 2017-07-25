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
   
  train_step.evalwith({x,zeros(10,784),y_,zeros(10,10)});
  
  correct_prediction = EqualOp(ArgmaxOp(y, 1), ArgmaxOp(y_, 1));
  accuracy = ReduceMeanOp(correct_prediction); 

  train_accuracy = accuracy.evalwith({x,zeros(128,784),y_,zeros(128,10)});
  
  % batches of 100
