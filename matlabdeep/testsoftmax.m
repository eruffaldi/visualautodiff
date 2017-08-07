%%
addpath ../logreg_mnist
useadam=1;
DeepOp.setgetDefaultType(single(0));
%%
  x = Placeholder('float',[-1, 784]);
  W = Variable('W',zeros([784,10])); %(truncated_normal_gen([784,10],0,0.1,'float')); %zeros([784, 10]));
  b = Variable('b',0.1*mzeros([1,10])); %zeros([10,1]));
  y = AddOp(MatmulOp(x,W),b);
  %y = AddOp(y,b); % for testing unique variable selection
  y_ = Placeholder('float',[-1,10]);

  %Plain:
  %   ReduceMeanOp(-ReduceSumOp(y_ * LogOp(SoftMaxOp(y)),1)
  %Optimized:0
  % A 1-D Tensor of length batch_size of the same type as logits with the softmax cross entropy loss.
  if 1==1
      cross_entropy = ReduceMeanOp(softmax_cross_entropy_with_logits(y_,y),0);
  else
      p_y_given_x = SoftmaxOp(y);
      rs = ReduceSumOp(MatmulwiseOp(y_,LogOp(p_y_given_x)),2); 
      cross_entropy = ReduceMeanOp(NegateOp(rs),0);
  end
  if useadam == 0
  train_step = GradientDescentOptimizer(0.05,cross_entropy);
  else
      train_step = AdamOptimizer(1e-4,cross_entropy);
  end

  train_step.variables
   correct_prediction = EqualOp(ArgmaxOp(y, 2), ArgmaxOp(y_, 2));
accuracy = ReduceMeanOp(correct_prediction,0); 

%%
disp('Initial Values')
for I=1:length(train_step.variables)
    train_step.variables{I}.xvalue;
end


%accuracyfake = ReduceMeanOp(EqualOp(ArgmaxOp(y, 2), ArgmaxOp(y_, 2))); 


mtr = MnistBatcher("train");
train_step.reset();
accuracyhistory = [];
losshistory = [];
speedtest = 1;
tic 
for I=1:1000
    [batch_xs,~,batch_ys] = mtr.next(100);
    loss = train_step.evalwith({x,(batch_xs),y_,(batch_ys)});
    losshistory(I) = loss;
    if speedtest == 0 && mod(I,20) == 0
        [whole_xs,~,whole_ys] = mtr.whole();
        test_accuracy = accuracy.evalwith({x,whole_xs,y_,whole_ys});
        accuracyhistory(end+1) = test_accuracy;
    end
    
end
training_time = toc;
if ~isempty(accuracyhistory)
    figure(1)

accuracyhistory
plot(accuracyhistory)
title('accuracy History');
xlabel('Iteration');
ylabel('accuracy');

end

figure(2);
losshistory
plot(losshistory)
title('Loss History');
xlabel('Iteration');
ylabel('Loss');

%%
mte = MnistBatcher("test");

[test_images,~,test_labels] = mte.whole();
if(exist('bout'))
    b.set(squeeze(bout.Data(:,end))');
    W.set(squeeze(Wout.Data(:,:,end)));
end
accuracy.evalshapewith({x,test_images,y_,test_labels})
test_accuracy = accuracy.evalwith({x,test_images,y_,test_labels})
prediction = ArgmaxOp(y, 2).evalwith({x,test_images});
training_time
%should give 1.0
%accuracyfake = ReduceMeanOp(EqualOp(ArgmaxOp(y_, 1), ArgmaxOp(y_, 1))); 
%train_accuracyfake = accuracyfake.evalwith({x,test_images,y_,test_labels})
%%
disp('Final Values')
for I=1:length(train_step.variables)
    v = train_step.variables{I};
    disp(sprintf('Variable %s',v.name))
   	v.xvalue;
end

% Tensorflow: 91%
% Tensorflow ADAM: 92%

