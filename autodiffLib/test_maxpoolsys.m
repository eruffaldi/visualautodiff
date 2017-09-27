%%
addpath ../commondeep
addpath ../matlabdeep


%% Declare Input and W
X = rand([2,16,16,2]);
U_B_Ph_Pw_Q = rand([size(X,1),size(X,2)/2,size(X,3)/2,size(X,4)]);

%% Execute the DeepOp approach
pX = Variable('float',X);
pO = MaxPoolOp(pX,[1 2 2 1],[1, 2, 2, 1],'SAME');
% if X is variable we skip the evalwith and call evalshape and eval
%pO.evalwith({pX,X});
pO.evalshape();
pO.eval(); % so we skip
pO.grad(U_B_Ph_Pw_Q);
Ym = pO.xvalue;
JXm = pX.xgrad;

%% Execute the System Object 
ssetup = maxpool_setup();
seval = maxpool_eval();
sgrad = maxpool_grad();
seval.ksize = ssetup.ksize;
seval.strides = ssetup.strides;
sgrad.ksize = ssetup.ksize;
sgrad.strides = ssetup.strides;

X_B_I_C = X;
[Sel_PCK_IC,argmaxbase,argmaxbasescale,Zero_Ph_Pw,Sel_PCK_IC_A] = step(ssetup,X);
[y_B_P_C,maxindices_BPC] = step(seval,X_B_I_C,Sel_PCK_IC,Zero_Ph_Pw);
[J_BIC] = step(sgrad,U_B_Ph_Pw_Q,argmaxbase,maxindices_BPC,argmaxbasescale,Zero_Ph_Pw,X_B_I_C,Sel_PCK_IC,Sel_PCK_IC_A);
JXs = J_BIC;
Ys = y_B_P_C;

%%
assert(all(size(Ys)==size(Ym)),'same Y');
assert(all(size(JXs)==size(JXm)),'same J');
deltaY = Ys-Ym;
deltaJ = JXs-JXm;
norm(deltaJ(:))
norm(deltaY(:))