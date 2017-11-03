%%

if exist('testtestsoft','var') == 0
    testtestsoft = 0;
end

if testtestsoft == 0

    speedtest = 1;

    useadam=0;
    deftype = DeepOp.setgetDefaultType(gpuArray(single(0)));
    deftype = DeepOp.setgetDefaultType(single(0));
    training_time=0;
    batchsize = 100;
    epochs = 10;
end
%deftype = DeepOp.setgetDefaultType(single(0));
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
  gradient_rate = 0.5;
  adam_rate = 1e-4;
  if useadam == 0
    train_step = GradientDescentOptimizer(gradient_rate,cross_entropy);
  else
      train_step = AdamOptimizer(adam_rate,cross_entropy);
  end

%  train_step.variables
  predict_op = ArgmaxOp(y, 2);
   correct_prediction = EqualOp(predict_op, ArgmaxOp(y_, 2));
accuracy = ReduceMeanOp(correct_prediction,0); 

%%
if testtestsoft ~= 0
disp('Initial Values')
for I=1:length(train_step.variables)
    train_step.variables{I}.xvalue;
end
end

%accuracyfake = ReduceMeanOp(EqualOp(ArgmaxOp(y, 2), ArgmaxOp(y_, 2))); 


mtr = MnistBatcher("train");
train_step.reset();
steps = 60000/batchsize*epochs;
losshistory = mzeros(steps,DeepOp.setgetDefaultType());
accuracyhistory = losshistory;
tic 
for I=1:steps
    [batch_xs,~,batch_ys] = mtr.next(batchsize);
    loss = train_step.evalwith({x,(batch_xs),y_,(batch_ys)});
    losshistory(I) = loss;
    if speedtest == 0 && mod(I,10) == 0
        I
        %[whole_xs,~,whole_ys] = mtr.whole();
        %test_accuracy = accuracy.evalwith({x,whole_xs,y_,whole_ys});
        %accuracyhistory(I) = test_accuracy;
    end
    
%     if speedtest == 0 && mod(I,20) == 0
%         [whole_xs,~,whole_ys] = mtr.whole();
%         test_accuracy = accuracy.evalwith({x,whole_xs,y_,whole_ys});
%         accuracyhistory(I) = test_accuracy;
%     end
    
end
training_time = toc;

if testtestsoft == 0
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
    training_time
end

%%

mte = MnistBatcher("test");

[test_images,test_label,test_labelshot] = mte.whole();
if(exist('bout'))
    disp('Using weights from Simulin')
    b.set(squeeze(bout.Data(:,end))');
    W.set(squeeze(Wout.Data(:,:,end)));
end
tic;
%accuracy.evalshapewith({x,test_images,y_,test_labels})
accuracy = gather(accuracy.evalwith({x,test_images,y_,test_labelshot}));
testing_time = toc;
%prediction = predict_opl.evalwith({x,test_images});
prediction = gather(predict_op.xvalue)-1; % because we go from argmax to 0-9
stats = multiclassinfo(cast(test_label,'like',prediction),prediction);
if testtestsoft==0
accuracy
end

%should give 1.0
%accuracyfake = ReduceMeanOp(EqualOp(ArgmaxOp(y_, 1), ArgmaxOp(y_, 1))); 
%train_accuracyfake = accuracyfake.evalwith({x,test_images,y_,test_labels})
%%
if testtestsoft==0
    disp('Final Values')
    for I=1:length(train_step.variables)
        v = train_step.variables{I};
        disp(sprintf('Variable %s',v.name))
        v.xvalue;
    end
end

% Tensorflow: 91%
% Tensorflow ADAM: 92%

