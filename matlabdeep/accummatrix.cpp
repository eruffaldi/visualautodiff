/**
 Accum Matrix:
    accummatrix(subsCOL,val_matrix,outdim)
 
 Returns a matrix of dimension:  [size(val_matrix,1),outdim]
 accumulating the output by picking subscripts for each row of val_matrxi

*/
#ifndef NOMATLAB
#include "mex.h"   
#else
#include <iostream>
#endif
#include <array>
#include <memory>
#include <algorithm>

// works iterating by row of input
//
// take the subs as indices to the 
template <class T>
void accummatrix_cols(T * pdata,int rows,int cols,int32_t * psubs,int nsubs,T * pout,int outcols)
{
    // nsubs <= cols
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
}


// argmax(data,dim,sametypeindex)
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if(nrhs != 3 || nlhs != 1)
    {
        mexPrintf("accummatrix Emanuele Ruffaldi 2017\naccummatrix(S=subs_of_col,A=val_matrix,n=size_out_cols)");
        return;
    }
    if(mxIsSparse(prhs[0]) || mxIsComplex(prhs[0]) || mxGetNumberOfDimensions(prhs[0]) != 2 || mxGetClassID(prhs[0]) != mxINT32_CLASS)
    {
        mexErrMsgTxt("S: has to be int32, monodimensional, full, non-complex\n");
        return;
    }
    if(mxIsSparse(prhs[1]) || mxIsComplex(prhs[1]) || mxGetNumberOfDimensions(prhs[1]) != 2)
    {
        mexErrMsgTxt("A: sparse or comples not supported\n");
        return;
    }
    if(!mxIsScalar(prhs[2]))
    {
        mexErrMsgTxt("n scalar");
        return;
    }    
	// dimension argument
    auto outcols = (int)mxGetScalar(prhs[2]);
    if(outcols <= 0)
    {
        mexErrMsgTxt("n positive");
        return;
    }
    switch(mxGetClassID(prhs[1]))
    {
        case mxDOUBLE_CLASS:
            break;
        case mxSINGLE_CLASS:
            break;
        default:
            mexErrMsgTxt("A: Unsupported type");
            break;
    }
	const mwSize * dimi = mxGetDimensions(prhs[1]);
    int rows = dimi[0];
    int cols = dimi[1];
    int nsubs = mxGetNumberOfElements(prhs[0]);
    if(nsubs > cols)   
    {
        mexErrMsgTxt("S: larger than input columns");
        return;
    }
    mwSize dimo[2] = { (mwSize)rows, (mwSize)outcols };
    // zero inited
    plhs[0] = mxCreateNumericArray(2,(mwSize*)dimo,mxGetClassID(prhs[1]),mxREAL);
    int32_t * psubs = (int32_t*)mxGetData(prhs[0]);
    void * pdata = (void*)mxGetData(prhs[1]);
    void * pout  = (void*)mxGetData(plhs[0]);
    switch(mxGetClassID(prhs[1]))
    {
        case mxDOUBLE_CLASS:
            accummatrix_cols<double>((double*)pdata,rows,cols,psubs,nsubs,(double*)pout,outcols);
            break;
        case mxSINGLE_CLASS:
            accummatrix_cols<float>((float*)pdata,rows,cols,psubs,nsubs,(float*)pout,outcols);
            break;
        default:
            mexErrMsgTxt("Unsupported type");
            break;
    }
}    
