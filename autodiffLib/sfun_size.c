
/*
 * Outputs:
 * - time absolute
 * - reference time
 * 
 * Sampling (also 0 for timeonly)
 *
 * 
 */
#define S_FUNCTION_NAME                 sfun_size
#define S_FUNCTION_LEVEL                2

/*
 * Need to include simstruc.h for the definition of the SimStruct and
 * its associated macro definitions.
 */
#include "simstruc.h"


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
  if (!ssSetNumInputPorts(S, 1)) return;

  /*
   * Set the number of output ports.
   */
  if (!ssSetNumOutputPorts(S, 1)) return;

  ssSetInputPortDimensionInfo(S, 0, DYNAMIC_DIMENSION);
  ssSetInputPortWidth(S, 0, DYNAMICALLY_SIZED);
  ssSetInputPortComplexSignal(S, 0, COMPLEX_NO);
  ssSetInputPortOptimOpts(S, 0, SS_NOT_REUSABLE_AND_GLOBAL);
  ssSetInputPortDataType(S, 0, DYNAMICALLY_TYPED);
  //ssSetInputPortDimensionsMode(S, 0, INHERIT_DIMS_MODE);
  //ssRegMdlSetInputPortDimensionsModeFcn(S, mdlSetInputPortDimsMode);

  ssSetOutputPortWidth(S, 0, DYNAMICALLY_SIZED);
  ssSetOutputPortComplexSignal(S, 0, COMPLEX_NO);
  ssSetOutputPortOptimOpts(S, 0, SS_NOT_REUSABLE_AND_GLOBAL);
  ssSetOutputPortOutputExprInRTW(S, 0, 0);
  ssSetOutputPortDataType(S, 0, SS_INT32);
  
  ssSetOptions(S,SS_OPTION_CAN_BE_CALLED_CONDITIONALLY | SS_OPTION_EXCEPTION_FREE_CODE |SS_OPTION_WORKS_WITH_CODE_REUSE |SS_OPTION_ALLOW_CONSTANT_PORT_SAMPLE_TIME);
  
  ssSetOutputPortSampleTime(S, 0, mxGetInf());
  ssSetOutputPortOffsetTime(S, 0, 0);
  
  
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
}
#endif

 #if defined(MATLAB_MEX_FILE)
#define MDL_SET_DEFAULT_PORT_DIMENSION_INFO
void mdlSetDefaultPortDimensionInfo(SimStruct *S)
{
    
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
    if(tid == CONSTANT_TID)
    {
          int_T *out = (int_T *) ssGetOutputPortSignal(S, 0);
          memcpy(out,ssGetInputPortDimensions(S,0),ssGetInputPortNumDimensions(S,0)*sizeof(int_T));
    }   
}

static void setOutputDims(SimStruct *S, 
                          int_T outIdx, 
                          int_T *inputs, 
                          int_T numInputs)
{
    ssSetCurrentOutputPortDimensions(S, 0, 0, 
                                     ssGetCurrentInputPortDimensions(S, 0, 0));
    ssSetCurrentOutputPortDimensions(S, 0, 1, 
                                     ssGetCurrentInputPortDimensions(S, 0, 1));
    UNUSED_ARG(numInputs);
    UNUSED_ARG(inputs);
    UNUSED_ARG(outIdx);
}


/* Function: mdlTerminate =================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.
 */
static void mdlTerminate(SimStruct *S)
{
}

static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, mxGetInf());
    ssSetOffsetTime(S, 0, 0);  
}

#define MDL_SET_OUTPUT_PORT_DIMENSION_INFO
void mdlSetOutputPortDimensionInfo(SimStruct *S, int_T port,
  const DimsInfo_T *dimsInfo)
{
}

#define MDL_SET_INPUT_PORT_DIMENSION_INFO
void mdlSetInputPortDimensionInfo(SimStruct *S, int_T port,
  const DimsInfo_T *dimsInfo)
{
    if(!ssSetInputPortDimensionInfo(S, port, dimsInfo)) return;
    int n = dimsInfo->numDims;
    if(n == 0)
        return; // disconnected case
    int dims[2] = {1, n};
    DimsInfo_T odimsInfo;
    odimsInfo.width = n;
    odimsInfo.numDims = 2;
    odimsInfo.dims = dims;
    ssSetOutputPortDimensionInfo(S,0,&odimsInfo);
}
/*
 * Required S-function trailer
 */
#ifdef MATLAB_MEX_FILE
# include "simulink.c"
#else
# include "cg_sfun.h"
#endif
