/*
 * Outputs:
 * - time absolute
 * - reference time
 *
 * Sampling (also 0 for timeonly)
 *
 *
 */
#define S_FUNCTION_NAME                 sfun_loadmnist
#define S_FUNCTION_LEVEL                2

/*
 * Need to include simstruc.h for the definition of the SimStruct and
 * its associated macro definitions.
 */
#include "simstruc.h"
#include <stdint.h>
#include <stdio.h>

#define O_TYPE float
#define O_TYPE_SPEC SS_SINGLE


/* Function: mdlInitializeSizes ===========================================
 * Abstract:
 *    The sizes information is used by Simulink to determine the S-function
 *    block's characteristics (number of inputs, outputs, states, etc.).
 */
static void mdlInitializeSizes(SimStruct *S)
{
    
    /*
     * Set the number of input ports.
     */
    if (!ssSetNumInputPorts(S, 0)) return;
    
    /*
     * Set the number of output ports.
     */
    if (!ssSetNumOutputPorts(S, 4)) return;
    ssSetNumSFcnParams(S,1);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) return;
    
    int train = *(double*)mxGetData(ssGetSFcnParam(S,0)) != 0;
    int nitems = train ? 60000 : 10000;
    
    ssSetOutputPortWidth(S, 0, 1);
    ssSetOutputPortMatrixDimensions(S, 0, nitems,784);
    ssSetOutputPortComplexSignal(S, 0, COMPLEX_NO);
    ssSetOutputPortOptimOpts(S, 0, SS_NOT_REUSABLE_AND_GLOBAL);
    ssSetOutputPortOutputExprInRTW(S, 0, 0);
    ssSetOutputPortDataType(S, 0, SS_UINT8);
    
    ssSetOutputPortWidth(S, 1, 1);
    ssSetOutputPortMatrixDimensions(S, 1, nitems,1);
    ssSetOutputPortComplexSignal(S, 1, COMPLEX_NO);
    ssSetOutputPortOptimOpts(S, 1, SS_NOT_REUSABLE_AND_GLOBAL);
    ssSetOutputPortOutputExprInRTW(S, 1, 0);
    ssSetOutputPortDataType(S, 1, SS_UINT8);
    
    ssSetOutputPortWidth(S, 2, 1);
    ssSetOutputPortMatrixDimensions(S,2 , nitems,10);
    ssSetOutputPortComplexSignal(S, 2, COMPLEX_NO);
    ssSetOutputPortOptimOpts(S, 2, SS_NOT_REUSABLE_AND_GLOBAL);
    ssSetOutputPortOutputExprInRTW(S, 2, 0);
    ssSetOutputPortDataType(S, 2, O_TYPE_SPEC);
    
    
    ssSetOutputPortWidth(S, 3, 1);
    ssSetOutputPortMatrixDimensions(S,3 , nitems,784);
    ssSetOutputPortComplexSignal(S, 3, COMPLEX_NO);
    ssSetOutputPortOptimOpts(S, 3, SS_NOT_REUSABLE_AND_GLOBAL);
    ssSetOutputPortOutputExprInRTW(S, 3, 0);
    ssSetOutputPortDataType(S, 3, O_TYPE_SPEC);
    
    ssSetNumIWork(S,1);
    /*
     * Set the number of sample time.
     */
    ssSetNumSampleTimes(S, 1);
    
    /*
     * All options have the form SS_OPTION_<name> and are documented in
     * matlabroot/simulink/include/simstruc.h. The options should be
     * bitwise or'd together as in
     *   ssSetOptions(S, (SS_OPTION_name1 | SS_OPTION_name2))
     */
    ssSetOptions(S,SS_OPTION_CAN_BE_CALLED_CONDITIONALLY | SS_OPTION_EXCEPTION_FREE_CODE |SS_OPTION_WORKS_WITH_CODE_REUSE |SS_OPTION_DISALLOW_CONSTANT_SAMPLE_TIME);
}


#define MDL_START
#if defined(MDL_START)
/* Function: mdlStart =====================================================
 * Abstract:
 *    This function is called once at start of model execution. If you
 *    have states that should be initialized once, this is the place
 *    to do it.
 */
static void mdlStart(SimStruct *S)
{
    ssSetIWorkValue(S,0,0);
}
#endif

/* Function: mdlOutputs ===================================================
 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block. Generally outputs are placed in the output vector(s),
 *    ssGetOutputPortSignal.
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    if(ssGetIWorkValue(S,0) == 0)
    {
        ssPrintf("loading MNIST data\n");
        ssSetIWorkValue(S,0,1);
        uint8_t *yimage = (uint8_t *) ssGetOutputPortSignal(S, 0);
        int8_t *ylabels = (int8_t *) ssGetOutputPortSignal(S, 1);
        O_TYPE *yhot = (O_TYPE *) ssGetOutputPortSignal(S, 2);
        O_TYPE *dyimage = (O_TYPE *) ssGetOutputPortSignal(S, 3);
        int train = *(double*)mxGetData(ssGetSFcnParam(S,0)) != 0;
        int nitems = train ? 60000 : 10000;
        
        const char * imagefile = train ? "train-images-idx3-ubyte-le" : "t10k-images-idx3-ubyte-le";
        const char * labelfile = train ? "train-labels-idx1-ubyte-le" : "t10k-labels-idx1-ubyte-le";
        FILE * fp;
        fp = fopen(labelfile,"rb");
        if(fp)
        {
            int32_t magic = 0,numLabels = 0;
            fread(&magic,1,sizeof(magic),fp);
            fread(&numLabels,1,sizeof(numLabels),fp);
            if(numLabels == nitems && magic == 2049)
            {
                fread(ylabels,nitems,1,fp);
                memset(yhot,0,nitems*10*sizeof(O_TYPE));
                int i ;
                for ( i = 0; i < nitems; i++)
                {
                    // 10,nitems: yhot[i*10+ylabels[i]] = 1;
                    yhot[ylabels[i]*nitems+i] = 1;
                }
            }
            else
            {
                ssPrintf("Bad magic or labels %d %d\n",magic,numLabels);
                ssSetErrorStatus(S,"abort bad file");
            }
            fclose(fp);
            ssPrintf("loaded MNIST data\n");
        }
        else
        {
            ssPrintf("Cannot open file %s\n",imagefile);
            ssSetErrorStatus(S,"abort missing file");
        }
        fp = fopen(imagefile,"rb");
        if(fp)
        {
            int32_t magic, numImages, numRows, numCols;
            fread(&magic,1,sizeof(magic),fp);
            fread(&numImages,1,sizeof(numImages),fp);
            fread(&numRows,1,sizeof(numRows),fp);
            fread(&numCols,1,sizeof(numCols),fp);
            if(magic == 2015 && numImages == nitems && numRows == 28 && numCols == 28)
            {
                int q = numImages*numRows*numCols;
                int i;
                fread(yimage,q,1,fp);
                for ( i = 0; i < q; i++)
                {
                    dyimage[i] = (O_TYPE)(yimage[i])/255.0;
                }
            }
            else
            {
                ssPrintf("Bad magic %d or images %d or size %d %d\n",magic,numImages,numRows,numCols);
                ssSetErrorStatus(S,"abort bad file content");
            }
            fclose(fp);
        }
        else
        {
            ssPrintf("Cannot open file %s\n",imagefile);
        }
    } // only first step    
}

/* Function: mdlTerminate =================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.
 */
static void mdlTerminate(SimStruct *S)
{
}

static void mdlizeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, -1);
    ssSetOffsetTime(S, 0, 0.0);
}

/*
 * Required S-function trailer
 */
#ifdef MATLAB_MEX_FILE
# include "simulink.c"
#else
# include "cg_sfun.h"
#endif
