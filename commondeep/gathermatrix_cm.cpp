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
void gathermatrix_cols(T * pdata,int rows,int cols,int32_t * psubs,int nsubs,T * pout,int outrows)
{
    for(int itarget_row = 0; itarget_row < nsubs; itarget_row++)
    {
        auto input_row = psubs[itarget_row];
        if(input_row > 0) // SKIPPED input_col <= cols
        {
            input_row--; // 1-based with 0 as null
            for(int c = 0; c < cols; c++)
            {
                pout[itarget_row+c*rows] = pdata[input_row+c*rows];
            }
        }
    }
    // excess columns if ny DUE to Uninited
    for(int itarget_row = nsubs; itarget_row < outrows; itarget_row++)
    {
        for(int c =  0; c < cols; c++)
        {
            pout[itarget_row+c*rows] = 0; 
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
            gathermatrix_cols<double>((double*)pdata,rows,cols,psubs,nsubs,(double*)pout,outcols);
            break;
        case mxSINGLE_CLASS:
            gathermatrix_cols<float>((float*)pdata,rows,cols,psubs,nsubs,(float*)pout,outcols);
            break;
        case mxINT32_CLASS:
            gathermatrix_cols<int32_t>((int32_t*)pdata,rows,cols,psubs,nsubs,(int32_t*)pout,outcols);
            break;
        case mxINT64_CLASS:
            gathermatrix_cols<int64_t>((int64_t*)pdata,rows,cols,psubs,nsubs,(int64_t*)pout,outcols);
            break;
        default:
            mexErrMsgTxt("Unsupported type");
            break;
    }
}    
