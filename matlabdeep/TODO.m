https://github.com/marcsous/gpuSparse


Starting point for C++: http://svt.stanford.edu/code/mexFiles/smvp.c


We need in munpatcher and mpatcher

as*Sel' === (Sel*as')'
Xpm*Sel

These product are not good for BLAS/col-major (http://math.nist.gov/spblas/) that rather specifies AB and A'B 
Moreover Sel is a logic sparse matrix with two different semantics:

http://www.netlib.org/blas/blasqr.pdf

- mpatcher acts like a gather from small image to larget patch and for each output variable
  there is a single input so it can be simplified in the inner loop (pick one)
- munpatch being of logical is simply a summation of picked elementns


  
       
  


Approach: use structure equivalent to the one of Matlab
    ir = mxGetIr(prhs[0]);      /* Row indexing      */
    jc = mxGetJc(prhs[0]);      /* Column count      */
    s  = mxGetPr(prhs[0]);      /* Non-zero elements */
    
    
for (i=0; i<ncol; i++) {            /* Loop through columns */
            stop = jc[i+1]; 
            rhs = b[i];
            for (k=jc[i]; k<stop; k++) {    /* Loop through non-zeros in ith column */
                x[ir[k]] += s[k] * rhs;
            }
        }
        
-----
Actually we need BLAS Level 3
Sparse Repr
    values
    rowidx points to colidx[i] colidx[i+1] and values
    colidx contains the indices
Problem with A=Sel
    B*A' === (A *B')'
    B*A  === (A' B')'

USMM  with A sparse and B,C dense
    C <- alpha AB + C
    C <- alpha A' B + C
    
    void hblas_sgemm(const enum HBLAS_ORDER Order, const enum HBLAS_TRANSPOSE TransA,
                 const enum HBLAS_TRANSPOSE TransB, const int M, const int N,
                 const int K, const float alpha, const float *A,
                 const int lda, const float *B, const int ldb,
                 const float beta, float *C, const int ldc);

Halide has no sparse
    