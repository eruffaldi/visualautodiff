% Assessment of the Softmax in C++
% TODO: compare in Python of TensorFlow
%
mysetup('json');
%% Declare Input and W
X1 = rand([100,2]); % logits 
X2 = floor(rand([100,2])*10); % labels

U = 1;

%%
ss = [];
ss.logits = X1;
ss.labels = X2;
filewrite('input.json',jsonencode(ss));
%%
system('python ../commondeep/eval_softmax_logits.py');

%%
tfdata = jsondecode(fileread('output.json'));

%% Execute the DeepOp approach
pX1 = Variable('float',X1);
pX2 = Variable('float',X2);
pO = softmax_cross_entropy_with_logits(pX2,pX1); % labels,logits
pO.classdim = 2;
% if X is variable we skip the evalwith and call evalshape and eval
%pO.evalwith({pX,X});
pO.evalshape();
pO.eval(); % so we skip
pO.grad(U);
Ym = pO.xvalue;
JX1m = pX1.xgrad;
%%
assert(all( tfdata.output.data == Ym),'same Y');

%%
figure(1);
plot(tfdata.output.data-Ym)
xlabel('Sample');
ylabel('Output TF vs Ym');

%% Execute the System Object 
seval = softmax_cross_entropy_with_logitsSystem('classdim',2);
sgrad = softmax_cross_entropy_with_logitsGradSystem('classdim',2);
[Ys,logitsoffsetted,sumx] = step(seval,X1,X2);
JX1s = step(sgrad,X1,X2,U,logitsoffsetted,sumx);

%%
figure(2);
plot(tfdata.output.data-Ys)
xlabel('Sample')
ylabel('Output TF vs Ys');
figure(3);
plot(Ym-Ys)
xlabel('Sample');
ylabel('Output Ym vs Ys');
%%
assert(all(size(Ys)==size(Ym)),'same Y');
assert(all(size(JX1s)==size(JX1m)),'same J1');
deltaY = Ys-Ym;
deltaJ1 = JX1s-JX1m;
norm(deltaJ1(:))
norm(deltaY(:))