% codegen -report test_maxpool_eval_gen -args {0}
function [y_B_P_C,J_BIC] = test_maxpool_eval_gen()

%#codegen
    X = rand([2,28,28,2]);
    U_B_Ph_Pw_Q = rand([size(X,1),size(X,2)/2,size(X,3)/2,size(X,4)]);

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


end    