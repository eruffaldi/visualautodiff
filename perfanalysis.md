
1) fully written matrix is zeroed with memset => coder.nullcopy for gather
2) increment is performed in two steps  
  Y_rows_Cout(:,itarget_col) = Y_rows_Cout(:,itarget_col) + X_rows_Cin(:,input_col);
  vs


------  
  int32_T b_input_col;
  real32_T Y_rows_Cout_0[64];
  int32_T i;

  /* Start for MATLABSystem: '<S11>/Gradient' */
  /*  Gather Matrix */
  memset(&Y_rows_Cout[0], 0, 200704U * sizeof(real32_T)); /// AARG
  for (b_input_col = 0; b_input_col < 3136; b_input_col++) {
    if ((idx[b_input_col] >= 1) && (idx[b_input_col] <= 3136)) {
      for (i = 0; i < 64; i++) {
        Y_rows_Cout_0[i] = Y_rows_Cout[((idx[b_input_col] - 1) << 6) + i] +
          X_rows_Cin[(b_input_col << 6) + i];
      }

      for (i = 0; i < 64; i++) {
        Y_rows_Cout[i + ((idx[b_input_col] - 1) << 6)] = Y_rows_Cout_0[i];
      }
    }
  }



vs



function Y_rows_Cout = accummatrix(idx,X_rows_Cin,Cout)
% Gather Matrix

rows = size(X_rows_Cin,1);
Cin = size(X_rows_Cin,2);
nsubs = length(idx);
assert(ismatrix(X_rows_Cin));
assert(nsubs <= Cin);
Y_rows_Cout = zeros([rows,Cout],'like',X_rows_Cin);

for input_col=1:length(idx)
    itarget_col = idx(input_col);
    if itarget_col >= 1 & itarget_col <= Cout
        Y_rows_Cout(:,itarget_col) = Y_rows_Cout(:,itarget_col) + X_rows_Cin(:,input_col);
    end
end 



  vs 

      for(int input_col = 0; input_col < nsubs; input_col++)
    {
        auto itarget_col = psubs[input_col];
        if(itarget_col > 0 && itarget_col <= outcols)
        {
            itarget_col--; // 0-based
            for(int r = 0; r < rows; r++)
            {
                pout[itarget_col*rows+r] += pdata[input_col*rows+r];
            }
        }
    }

----



static void mnist_cnn_adam_gathermatrixmat(const int32_T S[19600], const
  real32_T A[50176], real32_T out[1254400])
{
  int32_T b_itarget_col;
  int32_T i;

  /* Start for MATLABSystem: '<S29>/Value' */
  memset(&out[0], 0, 1254400U * sizeof(real32_T));
  for (b_itarget_col = 0; b_itarget_col < 19600; b_itarget_col++) {
    if (S[b_itarget_col] > 0) {
      for (i = 0; i < 64; i++) {
        out[i + (b_itarget_col << 6)] = A[((S[b_itarget_col] - 1) << 6) + i];
      }
    }
  }


assert(nsubs <= outcols);
out = coder.nullcopy(zeros([rows,outcols],'like',A));

for itarget_col=1:nsubs
    input_col = S(itarget_col);
    if input_col > 0
        out(:,itarget_col) = A(:,input_col);
    end
end
out(:,nsubs+1:end) = 0;


  for(int itarget_col = 0; itarget_col < nsubs; itarget_col++)
    {
        auto input_col = psubs[itarget_col];
        if(input_col > 0) // SKIPPED input_col <= cols
        {
            input_col--; // 1-based with 0 as null
            for(int r = 0; r < rows; r++)
            {
                pout[itarget_col*rows+r] = pdata[input_col*rows+r];
            }
        }
    }
    // excess columns if ny DUE to Uninited
    for(int itarget_col = nsubs; itarget_col < outcols; itarget_col++)
    {
        for(int r = 0; r < rows; r++)
        {
            pout[itarget_col*rows+r] = 0; 
        }
    }

  /* End of Start for MATLABSystem: '<S29>/Value' */
}



function out = gathermatrix(S,A,n)
%#codegen
rows = size(A,1);
cols = size(A,2);
nsubs = length(S);
outcols = n;

assert(nsubs <= outcols);
out = coder.nullcopy(zeros([rows,outcols],'like',A));

for itarget_col=1:nsubs
    input_col = S(itarget_col);
    if input_col > 0
        out(:,itarget_col) = A(:,input_col);
    end
end


// C gather

for(int itarget_col = 0; itarget_col < nsubs; itarget_col++)
    {
        auto input_col = psubs[itarget_col];
        if(input_col > 0) // SKIPPED input_col <= cols
        {
            input_col--; // 1-based with 0 as null
            for(int r = 0; r < rows; r++)
            {
                pout[itarget_col*rows+r] = pdata[input_col*rows+r];
            }
        }
    }
    // excess columns if ny DUE to Uninited
    for(int itarget_col = nsubs; itarget_col < outcols; itarget_col++)
    {
        for(int r = 0; r < rows; r++)
        {
            pout[itarget_col*rows+r] = 0; 
        }
    }


---
All time in accummatrix
-----------------------

mnist_cnn_adam/Conv2D Relu F2/Conv2D/Gradient (MATLABSystem.Outputs.Major)  898.98  49.4% 2034  0.441976  898.98  49.4% mnist_cnn_adam/Conv2D Relu F2/Conv2D/Gradient
  49

mnist_cnn_adam/Conv2D Relu F1/Conv2D/Gradient (MATLABSystem.Outputs.Major)  268.39  14.7% 2034  0.131952  268.39  14.7% mnist_cnn_adam/Conv2D Relu F1/Conv2D/Gradient
  14

mnist_cnn_adam/MaxPool F1/Gradient (MATLABSystem.Outputs.Major) 220.95  12.1% 2034  0.108628  220.95  12.1% mnist_cnn_adam/MaxPool F1/Gradient
  12

compileAndLinkPhase 113.83  6.2%  1 113.830000  113.83  6.2%  mnist_cnn_adam

mnist_cnn_adam/Conv2D Relu F2/Conv2D/Value (MATLABSystem.Outputs.Major) 91.72 5.0%  2034  0.045093  91.72 5.0%  mnist_cnn_adam/Conv2D Relu F2/Conv2D/Value
  5

mnist_cnn_adam/MaxPool F2/Gradient (MATLABSystem.Outputs.Major) 55.29 3.0%  2034  0.027183  55.29 3.0%  mnist_cnn_adam/MaxPool F2/Gradient
initializationPhase 44.98 2.5%  1 44.980000 43.49 2.4%  mnist_cnn_adam
  2.4
