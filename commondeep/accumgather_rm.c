
#include <stdint.h>

#define accummatrix_gen(T,DT,name)\
void accummatrix_##name(const T * pdata,int rows,int cols,const int32_t * psubs,int nsubs,DT * pout,int outcols)\
{\
    for(int input_col = 0; input_col < nsubs; input_col++)\
    {\
        int32_t itarget_col = psubs[input_col];\
        if(itarget_col > 0 && itarget_col <= outcols)\
        {\
            itarget_col--;\
            for(int r = 0; r < rows; r++)\
            {\
                pout[itarget_col*rows+r] += pdata[input_col*rows+r];\
            }\
        }\
    }\
}

#define gathermatrix_gen(T,DT,name)\
void gathermatrix_##name(const T * pdata,int rows,int cols,const int32_t * psubs,int nsubs,T * pout,int outcols)\
{\
    for(int itarget_col = 0; itarget_col < nsubs; itarget_col++)\
    {\
        int32_t input_col = psubs[itarget_col];\
        if(input_col > 0)\
        {\
            input_col--;\
            for(int r = 0; r < rows; r++)\
            {\
                pout[itarget_col*rows+r] = pdata[input_col*rows+r];\
            }\
        }\
    }\
    for(int itarget_col = nsubs; itarget_col < outcols; itarget_col++)\
    {\
        for(int r = 0; r < rows; r++)\
        {\
            pout[itarget_col*rows+r] = 0; \
        }\
    }\
}\
      
gathermatrix_gen(float,float,single)
gathermatrix_gen(double,double,double)
