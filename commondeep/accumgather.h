/*
 * #ifdef MATLAB_MEX_FILE
#include <tmwtypes.h>
#else
#include "rtwtypes.h"
#endif
*/
void accummatrix_float(const float * pdata,int rows,int cols,const int32_t * psubs,int nsubs,float * pout,int outcols);
void accummatrix_double(const double * pdata,int rows,int cols,const int32_t * psubs,int nsubs,double * pout,int outcols);

void gathermatrix_float(const float * pdata,int rows,int cols,const int32_t * psubs,int nsubs,float * pout,int outcols);
void gathermatrix_double(const double * pdata,int rows,int cols,const int32_t * psubs,int nsubs,double * pout,int outcols);
