
%% Declare Input and W
X1 = rand([2,28]);
X2 = rand([28,32]);
U = rand([2,32]);

%% Execute the DeepOp approach
pX1 = Variable('float',X1);
pX2 = Variable('float',X2);
pO = MatmulOp(pX1,pX2);
% if X is variable we skip the evalwith and call evalshape and eval
%pO.evalwith({pX,X});
pO.evalshape();
pO.eval(); % so we skip
pO.grad(U);
Ym = pO.xvalue;
JX1m = pX1.xgrad;
JX2m = pX2.xgrad;

%% Execute the System Object 
Ys = X1*X2;
JX1s = step(JBt_sys(),U,X2);
JX2s = step(AtJ_sys(),U,X1);

%%
assert(all(size(Ys)==size(Ym)),'same Y');
assert(all(size(JX1s)==size(JX1m)),'same J1');
assert(all(size(JX2s)==size(JX2m)),'same J2');
deltaY = Ys-Ym;
deltaJ1 = JX1s-JX1m;
deltaJ2 = JX2s-JX2m;
norm(deltaJ1(:))
norm(deltaJ2(:))
norm(deltaY(:))