%%
addpath ../commondeep
addpath ../matlabdeep


%% Declare Input and W
X = rand([2,28,28,2]);
U = X;

%% Execute the DeepOp approach
pX = Variable('float',X);
pO = ReluOp(pX);
% if X is variable we skip the evalwith and call evalshape and eval
%pO.evalwith({pX,X});
pO.evalshape();
pO.eval(); % so we skip
pO.grad(U);
Ym = pO.xvalue;
JXm = pX.xgrad;

%% Execute the System Object 
seval = Max0System();
sgrad = ReluGradient_sys();

Ys = step(seval,X);
JXs = step(sgrad,X,U); 

%%
assert(all(size(Ys)==size(Ym)),'same Y');
assert(all(size(JXs)==size(JXm)),'same J');
deltaY = Ys-Ym;
deltaJ = JXs-JXm;
norm(deltaJ(:))
norm(deltaY(:))