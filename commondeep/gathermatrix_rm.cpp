/**
 Gather Matrix:
    gathermatrix(subsCOL,val_matrix,outdim)
 
 Returns a matrix of dimension:  [size(val_matrix,1),outdim]
 Gathering data out of it

*/
#ifndef NOMATLAB
#include "mex.h"   
#else
#include <iostream>
#endif
#include <stdint.h>
#include <array>
#include <memory>
#include <algorithm>

// works iterating by row of input
//
// take the subs as indices to the 
template <class T>
void gathermatrix_rows(T * pdata,int rows,int cols,int32_t * psubs,int nsubs,T * pout,int outcols)
{
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
}


// argmax(data,dim,sametypeindex)
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if(nrhs != 3 || nlhs != 1)
    {
        mexPrintf("accummatrix Emanuele Ruffaldi 2017\ngathermatrix(S=subs_of_col,A=val_matrix,n=size_out_cols)");
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
        case mxINT32_CLASS:
            break;
        case mxINT64_CLASS:
            break;
        default:
            mexErrMsgTxt("A: Unsupported type");
            break;
    }
	const mwSize * dimi = mxGetDimensions(prhs[1]);
    int rows = dimi[0];
    int cols = dimi[1];
    int nsubs = mxGetNumberOfElements(prhs[0]);
    if(nsubs > outcols)   
    {
        mexErrMsgTxt("S: larger than output columns");
        return;
    }
    mwSize dimo[2] = { (mwSize)rows, (mwSize)outcols };
    // zero inited
    plhs[0] = mxCreateUninitNumericArray(2,(mwSize*)dimo,mxGetClassID(prhs[1]),mxREAL);
    int32_t * psubs = (int32_t*)mxGetData(prhs[0]);
    void * pdata = (void*)mxGetData(prhs[1]);
    void * pout  = (void*)mxGetData(plhs[0]);
    switch(mxGetClassID(prhs[1]))
    {
        case mxDOUBLE_CLASS:
            gathermatrix_rows<double>((double*)pdata,rows,cols,psubs,nsubs,(double*)pout,outcols);
            break;
        case mxSINGLE_CLASS:
            gathermatrix_rows<float>((float*)pdata,rows,cols,psubs,nsubs,(float*)pout,outcols);
            break;
        case mxINT32_CLASS:
            gathermatrix_rows<int32_t>((int32_t*)pdata,rows,cols,psubs,nsubs,(int32_t*)pout,outcols);
            break;
        case mxINT64_CLASS:
            gathermatrix_rows<int64_t>((int64_t*)pdata,rows,cols,psubs,nsubs,(int64_t*)pout,outcols);
            break;
        default:
            mexErrMsgTxt("Unsupported type");
            break;
    }
}    
