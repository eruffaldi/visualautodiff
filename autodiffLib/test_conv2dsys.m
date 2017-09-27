%%
addpath ../commondeep
addpath ../matlabdeep


%% Declare Input and W
X = rand([2,28,28,2]);
W = rand([5,5,size(X,4),3]); % Fh Fw Cin Cout
U_B_Ph_Pw_Q = rand([size(X,1),size(X,2),size(X,3),size(W,4)]);

%% Execute the DeepOp approach
pX = Variable('float',X);
pW = Variable('X',W);
pO = Conv2dOp(pX,pW,[1, 1, 1, 1],'SAME');
% if X is variable we skip the evalwith and call evalshape and eval
%pO.evalwith({pX,X});
pO.evalshape();
pO.eval(); % so we skip
pO.grad(U_B_Ph_Pw_Q);
Ym = pO.xvalue;
JXm = pX.xgrad;
JWm = pW.xgrad;

%% Execute the System Object 
ssetup = conv2d_setup();
seval = conv2d_eval();
sgrad = conv2d_grad();
X_B_I_C = X;
[Sel_PKC_IC,Zero_Ph_Pw] = step(ssetup,X_B_I_C,W);
[y_B_Ph_Pw_Q,Xp_BP_KC] = step(seval,X_B_I_C,W,Sel_PKC_IC,Zero_Ph_Pw);
[dzdx_B_Ph_Pw_Q,dzdW_K_C_Q] = step(sgrad,U_B_Ph_Pw_Q,X_B_I_C,W,Sel_PKC_IC,Xp_BP_KC);
Ys =y_B_Ph_Pw_Q;
JXs = dzdx_B_Ph_Pw_Q;
JWs = dzdW_K_C_Q;

%%
assert(all(size(Ys)==size(Ym)),'same Y');
assert(all(size(JXs)==size(JXm)),'same JX');
assert(all(size(JWs)==size(JWm)),'same JW');

deltaY = Ys-Ym;
deltaJW = JWs-JWm;
deltaJX = JXs-JXm;
norm(deltaY(:))
norm(deltaJW(:))
norm(deltaJX(:))