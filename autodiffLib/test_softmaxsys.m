% Assessment of the Softmax in C++
% TODO: compare in Python of TensorFlow
%
mysetup('json');
%% Declare Input and W
X1 = cast(rand([1000,2]),'single'); % logits 
X2 = cast((rand([1000,2])*10),'single'); % labels

U = 1;

%%
ss = [];
ss.logits = encodematrix4json(X1,'R');
ss.labels = encodematrix4json(X2,'R');
filewrite('input.json',jsonencode(ss));

%%
z = encodematrix4json(X1);
zu = decodematrix4json(z);
assert(all(all(zu == X1)));
z = encodematrix4json(X1,'R');
zu2 = decodematrix4json(z);
assert(all(all(zu2 == X1)));


%%
system('python ../commondeep/eval_softmax_logits.py');

tfdata = jsondecode(fileread('output.json'));
Yt = decodematrix4json(tfdata.output);

%% Execute the DeepOp approach
deftype = DeepOp.setgetDefaultType(single(0));
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


%% Execute the System Object 
seval = softmax_cross_entropy_with_logitsSystem('classdim',2);
sgrad = softmax_cross_entropy_with_logitsGradSystem('classdim',2);
[Ys,logitsoffsetted,sumx] = step(seval,X1,X2);
JX1s = step(sgrad,X1,X2,U,logitsoffsetted,sumx);

%%
figure(1);
plot(Yt-Ym)
xlabel('Sample');
ylabel('Output TF vs Ym');
figure(2);
plot(Yt-Ys)
xlabel('Sample')
ylabel('Output TF vs Ys');
figure(3);
plot(Ym-Ys)
norm(Yt-Ys)
norm(Ym-Ys)
xlabel('Sample');
ylabel('Output Ym vs Ys');
%%
assert(all(size(Ys)==size(Ym)),'same Y');
assert(all(size(JX1s)==size(JX1m)),'same J1');
deltaY = Ys-Ym;
deltaJ1 = JX1s-JX1m;
norm(deltaJ1(:))
norm(deltaY(:))