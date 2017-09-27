%%
addpath ../commondeep
addpath ../matlabdeep


%% Declare Input and W
X1 = rand([1,100]); % logits 
X2 = X1; % labels
X2(1:10:100) = 0;
U = 1;

%% Execute the DeepOp approach
pX1 = Variable('float',X1);
pX2 = Variable('float',X2);
pO = softmax_cross_entropy_with_logits(pX2,pX1); % labels,logits
% if X is variable we skip the evalwith and call evalshape and eval
%pO.evalwith({pX,X});
pO.evalshape();
pO.eval(); % so we skip
pO.grad(U);
Ym = pO.xvalue;
JX1m = pX1.xgrad;


%% Execute the System Object 
seval = softmax_cross_entropy_with_logitsSystem();
sgrad = softmax_cross_entropy_with_logitsGradSystem();
[Ys,logitsoffsetted,sumx] = step(seval,X1,X2);
JX1s = step(sgrad,X1,X2,U,logitsoffsetted,sumx);

%%
assert(all(size(Ys)==size(Ym)),'same Y');
assert(all(size(JX1s)==size(JX1m)),'same J1');
deltaY = Ys-Ym;
deltaJ1 = JX1s-JX1m;
norm(deltaJ1(:))
norm(deltaY(:))