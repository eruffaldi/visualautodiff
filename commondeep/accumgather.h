/*
 * #ifdef MATLAB_MEX_FILE
#include <tmwtypes.h>
#else
#include "rtwtypes.h"
#endif
*/
void accummatrix_cm_float(const float * pdata,int rows,int cols,const int32_t * psubs,int nsubs,float * pout,int outrows);
void accummatrix_cm_double(const double * pdata,int rows,int cols,const int32_t * psubs,int nsubs,double * pout,int outrows);

void gathermatrix_cm_float(const float * pdata,int rows,int cols,const int32_t * psubs,int nsubs,float * pout,int outrows);
void gathermatrix_cm_double(const double * pdata,int rows,int cols,const int32_t * psubs,int nsubs,double * pout,int outrows);

void accummatrix_rm_float(const float * pdata,int rows,int cols,const int32_t * psubs,int nsubs,float * pout,int outcols);
void accummatrix_rm_double(const double * pdata,int rows,int cols,const int32_t * psubs,int nsubs,double * pout,int outcols);

void gathermatrix_rm_float(const float * pdata,int rows,int cols,const int32_t * psubs,int nsubs,float * pout,int outcols);
void gathermatrix_rm_double(const double * pdata,int rows,int cols,const int32_t * psubs,int nsubs,double * pout,int outcols);
