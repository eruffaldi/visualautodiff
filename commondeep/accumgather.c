
#include <stdint.h>

#define accummatrix_rm_gen(T,DT,name)\
void accummatrix_rm_##name(const T * pdata,int rows,int cols,const int32_t * psubs,int nsubs,DT * pout,int outcols)\
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

accummatrix_rm_gen(float,float,single)
accummatrix_rm_gen(double,double,double)


#define gathermatrix_rm_gen(T,DT,name)\
void gathermatrix_rm_##name(const T * pdata,int rows,int cols,const int32_t * psubs,int nsubs,T * pout,int outcols)\
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
      
gathermatrix_rm_gen(float,float,single)
gathermatrix_rm_gen(double,double,double)





#define accummatrix_cm_gen(T,DT,name)\
void accummatrix_cm_##name(const T * pdata,int rows,int cols,const int32_t * psubs,int nsubs,DT * pout,int outrows)\
{\
    for(int input_row = 0; input_row < nsubs; input_row++)\
    {\
        int32_t itarget_row = psubs[input_row];\
        if(itarget_row > 0 && itarget_row <= itarget_row)\
        {\
            itarget_row--;\
            for(int c = 0; c < cols; c++)\
            {\
                pout[itarget_row+c*rows] += pdata[itarget_row+c*cols];\
            }\
        }\
    }\
}

accummatrix_cm_gen(float,float,single)
accummatrix_cm_gen(double,double,double)


#define gathermatrix_cm_gen(T,DT,name)\
void gathermatrix_cm_##name(const T * pdata,int rows,int cols,const int32_t * psubs,int nsubs,T * pout,int outrows)\
{\
    for(int itarget_row = 0; itarget_row < nsubs; itarget_row++)\
    {\
        int32_t input_row = psubs[itarget_row];\
        if(input_row > 0)\
        {\
            input_row--;\
            for(int c = 0; c < cols; c++)\
            {\
                pout[itarget_row+rows*c] = pdata[input_row+rows*c];\
            }\
        }\
    }\
    for(int itarget_row = nsubs; itarget_row < outrows; itarget_row++)\
    {\
        for(int c = 0; c < cols; c++)\
        {\
            pout[itarget_row+rows*c] = 0; \
        }\
    }\
}
      
gathermatrix_cm_gen(float,float,single)
gathermatrix_cm_gen(double,double,double)
