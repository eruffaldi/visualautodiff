%deftype = DeepOp.setgetDefaultType(gpuArray(single(0)));
deftype = DeepOp.setgetDefaultType((single(0)));

filtersize1 = 5;
filtersize2 = 5;
features1 = 16;
features2 = 16;
densesize = 64;
classes = 10;
batchsize = 64;
useadam=1;
weight_variable = @(name,shape) Variable(name,truncated_normal_gen(shape,0,0.1,deftype));
bias_variable = @(name,shape) Variable(name,0.1*mones(shape,deftype));
max_pool_2x2 =@(x) MaxPoolOp(x,[1, 2, 2, 1],[1, 2, 2, 1],'SAME'); 
conv2d = @(x,W) Conv2dOp(x,W,[1, 1, 1, 1],'SAME');

x = Placeholder('float',[-1,784]);
y_ = Placeholder('float',[-1,classes]);

x_image = ReshapeOp(x, [-1, 28, 28, 1]);

W_conv1 = weight_variable('W_conv1',[filtersize1, filtersize1, 1, features1]);
b_conv1 = bias_variable('b_conv1',[features1]);
h_conv1 = ReluOp(conv2d(x_image, W_conv1)+b_conv1);
h_pool1 = max_pool_2x2(h_conv1); h_pool1.name = 'h_pool1';

W_conv2 = weight_variable('W_conv2',[filtersize2, filtersize2, features1, features2]);
b_conv2 = bias_variable('b_conv2',[features2]);
h_conv2 = ReluOp(conv2d(h_pool1, W_conv2) + b_conv2);
h_pool2 = max_pool_2x2(h_conv2); h_pool2.name = 'h_pool2';
W_fc1 = weight_variable('W_fc1',[7 * 7 * features2, densesize]);
b_fc1 = bias_variable('b_fc1',[densesize]);
h_pool2_flat = ReshapeOp(h_pool2, [-1, 7*7*features2]);
h_fc1 = ReluOp(h_pool2_flat * W_fc1 + b_fc1);

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

mtr = MnistBatcher("train");
train_step.reset();
steps = 1000;
losshistory = mzeros(steps,DeepOp.setgetDefaultType());
accuracyhistory = losshistory;
speedtest = 0;
tic 
for I=1:steps
    [batch_xs,~,batch_ys] = mtr.next(batchsize);
    loss = train_step.evalwith({x,(batch_xs),y_,(batch_ys)});
    losshistory(I) = loss;
    if speedtest == 0 && mod(I,2) == 0
        %[whole_xs,~,whole_ys] = mtr.whole();
        %test_accuracy = accuracy.evalwith({x,whole_xs,y_,whole_ys});
        %accuracyhistory(I) = test_accuracy;
    end
    I
    
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
prediction = ArgmaxOp(y_conv, 2).evalwith({x,test_images});
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


%%
%correct_prediction = EqualOp(ArgmaxOp(y_conv, 2), ArgmaxOp(y_, 2));
%accuracy = ReduceMeanOp(correct_prediction,0); 

%train_accuracy = accuracy.evalwith({x,mzeros([batchsize,784],deftype),y_,mzeros([batchsize,classes],deftype),keep_prob, 1.0});
%cross_entropy.grad(1)

%test_accuracy = accuracy.evalwith({x,xtest,y_,ytest,keep_prob, 1.0});

