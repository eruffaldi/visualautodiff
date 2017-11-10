

%% Declare Input and W
X = rand([2,28,28,2]);
U = X;
rate = 0.8;

%% Execute the DeepOp approach
pX = Variable('float',X);
pp = Variable('float',rate);
rng(3);
pO = DropoutOp(pX,pp);
% if X is variable we skip the evalwith and call evalshape and eval
%pO.evalwith({pX,X});
pO.evalshape();
pO.eval(); % so we skip
pO.grad(U);
Ym = pO.xvalue;
JXm = pX.xgrad;

%% Execute the System Object 
seval = dropout_sys();
rng(3);
[Ys,M] = step(seval,X,rate);
JXs = U.*M;

%%
assert(all(size(Ys)==size(Ym)),'same Y');
assert(all(size(JXs)==size(JXm)),'same J');
deltaY = Ys-Ym;
deltaJ = JXs-JXm;
norm(deltaJ(:))
norm(deltaY(:))