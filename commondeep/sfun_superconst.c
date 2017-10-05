/*
 * File: sfun_port_constant.c
 * Abstract:
 *       A 'C' level 2 S-function that uses port based sample times with
 *       constant sample time. There are two outputs. The first is the input
 *       times the parameter. The second output is the parameter.  The second
 *       output is constant. The sample time of the first output matches the
 *       input and may be constant.
 *
 *  Copyright 1990-2009 The MathWorks, Inc.
 */

#define S_FUNCTION_NAME  sfun_superconst
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"
#if defined(MATLAB_MEX_FILE)
#include "mex.h"
#endif


/*====================*
 * S-function methods *
 *====================*/

#define MDL_CHECK_PARAMETERS
#if defined(MDL_CHECK_PARAMETERS) && defined(MATLAB_MEX_FILE)
/* Function: mdlCheckParameters =============================================
 * Abstract:
 *    Validate that the parameter is a finite real scalar
 */
static void mdlCheckParameters(SimStruct *S)
{
    const mxArray *m = ssGetSFcnParam(S,0);
    /*
     * if (mxGetNumberOfElements(m) != 1 ||
     * !mxIsNumeric(m) || !mxIsDouble(m) || mxIsLogical(m) ||
     * mxIsComplex(m) || mxIsSparse(m) || !mxIsFinite(mxGetPr(m)[0])) {
     * ssSetErrorStatus(S,"The parameter must be a real scalar value.");
     * return;
     * }*/
}
#endif /* MDL_CHECK_PARAMETERS */


/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *
 *    This S-function has:
 *        - one input
 *        - two outputs
 *        - one parameter
 *        - no work vectors or states
 *
 */
static void mdlInitializeSizes(SimStruct *S)
{
    int_T i =0;
    int_T nInputPorts  = 0;  /* number of input ports  */
    int_T nOutputPorts = 0;  /* number of output ports */
    int_T needsInput   = 1;  /* direct feed through    */
    int_T minParams = 3; // name,in,out
    int np = 0;
    mexPrintf("Begin mdlInitializeSizes\n");
    
    ssAllowSignalsWithMoreThan2D(S);
    np = ssGetSFcnParamsCount(S);
    if(np < minParams)
    {
        
    }
#if defined(MATLAB_MEX_FILE)
    ssSetNumSFcnParams(S,ssGetSFcnParamsCount(S));
#endif
    for(int i = 0; i < ssGetSFcnParamsCount(S); i++)
        ssSetSFcnParamTunable(S,i,SS_PRM_NOT_TUNABLE);
    
    /* Register the number and type of states the S-Function uses */
    ssSetNumContStates(    S, 0);   /* number of continuous states           */
    ssSetNumDiscStates(    S, 0);   /* number of discrete states             */
    
    if(np > 0)
    {
        if(mxGetClassID(ssGetSFcnParam(S,0)) != mxCHAR_CLASS)
        {
            ssSetErrorStatus(S,"first should be string");
            return;
        }
    }
    if(np > 1)
    {
        nInputPorts = (int)*mxGetPr(ssGetSFcnParam(S,1));
    }
    if(np > 2)
    {
        nOutputPorts = (int)*mxGetPr(ssGetSFcnParam(S,2));
    }
    
    /*
     * Configure the input ports. First set the number of input ports.
     */
    if (!ssSetNumInputPorts(S, nInputPorts)) return;
    //ssSetInputPortWidth(S, 0, 1);
    for(i = 0; i < nInputPorts;i++)
    {
        ssSetInputPortDimensionInfo( S, i, DYNAMIC_DIMENSION);
        ssSetInputPortDataType(S, i, DYNAMICALLY_TYPED);
        
        
        ssSetInputPortSampleTime(S, i, INHERITED_SAMPLE_TIME);
        ssSetInputPortOffsetTime(S, i, 0.0);
        
        // DONT'CARE ssSetInputPortDirectFeedThrough(S, i, 0);
    }
    
    mexPrintf("Inputs done\n");
    
    /*
     * Configure the output ports. First set the number of output ports.
     */
    if (!ssSetNumOutputPorts(S, nOutputPorts)) return;
    
    /*
     * Set output port dimensions for each output port index starting at 0.
     * See comments for setting input port dimensions.
     */
    
    
    
    for(int i = 0; i < nOutputPorts; i++)
    {
        ssSetOutputPortDimensionInfo( S, i, DYNAMIC_DIMENSION);
        ssSetOutputPortDataType(S, i, DYNAMICALLY_TYPED);
        
        ssSetOutputPortSampleTime(S, i, mxGetInf());
        ssSetOutputPortOffsetTime(S, i, 0.0);
    }
    mexPrintf("Outputs done\n");
    
    ssSetNumSampleTimes(S,PORT_BASED_SAMPLE_TIMES);
    
    mexPrintf("Samples done\n");
    /* No work vectors */
    ssSetNumRWork(         S, 0);
    ssSetNumIWork(         S, 0);
    ssSetNumPWork(         S, 0);
    ssSetNumModes(         S, 0);
    ssSetNumNonsampledZCs( S, 0);
    
    /* specify the sim state compliance to be same as a built-in block */
    ssSetSimStateCompliance(S, USE_DEFAULT_SIM_STATE);
    
    /* Want to be able to use constant sample time on the ports
     * so specify the option.
     *
     * Note that this will also allow a constant sample time to
     * be propagated to the s-function. If that is not desired it
     * must be caught in mdlSetInputPOrtSampleTime and
     * mdlSetOutputPortSampleTime.
     */
    ssSetOptions(S,
            SS_OPTION_WORKS_WITH_CODE_REUSE |
            SS_OPTION_EXCEPTION_FREE_CODE |
            SS_OPTION_ALLOW_PARTIAL_DIMENSIONS_CALL |
            SS_OPTION_ALLOW_CONSTANT_PORT_SAMPLE_TIME );
    
    mexPrintf("Ended mdlInitializeSizes\n");
} /* end mdlInitializeSizes */

#define MDL_SET_INPUT_PORT_SAMPLE_TIME
/*#define MDL_SET_INPUT_PORT_SAMPLE_TIME*/
#if defined(MDL_SET_INPUT_PORT_SAMPLE_TIME) && defined(MATLAB_MEX_FILE)
/* Function: mdlSetInputPortSampleTime =======================================
 * Abstract:
 *     Set the first output port sample time to be the same as the input
 *     port sample time.
 */
static void mdlSetInputPortSampleTime(SimStruct *S,
        int_T     portIdx,
        real_T    sampleTime,
        real_T    offsetTime)
{
//    for(int i = 0; i < ssGetNumInPorts(S); i++)
    //   {
    //ssSetOutputPortSampleTime(S,i,mxGetInf());
    //ssSetOutputPortOffsetTime(S,i,0);
    //(}
    ssSetInputPortSampleTime(S,portIdx,sampleTime);
    ssSetInputPortOffsetTime(S,portIdx,offsetTime);    
} /* end mdlSetInputPortSampleTime */
#endif /* MDL_SET_INPUT_PORT_SAMPLE_TIME */


#define MDL_SET_OUTPUT_PORT_SAMPLE_TIME
#if defined(MDL_SET_OUTPUT_PORT_SAMPLE_TIME) && defined(MATLAB_MEX_FILE)
/* Function: mdlSetOutputPortSampleTime ======================================
 * Abstract:
 *     Set the input port sample time to be the same as the first output
 *     port sample time.
 */
static void mdlSetOutputPortSampleTime(SimStruct *S,
        int_T     portIdx,
        real_T    sampleTime,
        real_T    offsetTime)
{
    mexPrintf("mdlSetOutputPortSampleTime port %d\n",portIdx);
    ssSetOutputPortSampleTime(S,portIdx,mxGetInf());
    ssSetOutputPortOffsetTime(S,portIdx,0);
    
} /* end mdlSetOutputPortSampleTime */
#endif /* MDL_SET_OUTPUT_PORT_SAMPLE_TIME */


/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *      Port based sample times have already been configured, therefore this
 *	method doesn't need to perform any action
 */
#define MDL_INITIALIZE_SAMPLE_TIMES
static void mdlInitializeSampleTimes(SimStruct *S)
{
    mexPrintf("mdlInitializeSampleTimes\n");
    ssSetSampleTime(S, 0, mxGetInf());
    ssSetOffsetTime(S, 0, 0.0);
    ssSetModelReferenceSampleTimeDefaultInheritance(S);
} /* end mdlInitializeSampleTimes */

static void callandsolve(SimStruct * S, int phase)
{
    // [outputdata1,outputdata2] = fx(phase,shapeincell,shapetypes,param1,...paramN)
    int i = 0;
    int j;
    char fxname[128];
    const int ninputs = ssGetNumInputPorts(S);
    const int noutputs = ssGetNumOutputPorts(S);
    const int nparams = ssGetSFcnParamsCount(S);
    fxname[0]=0;
    mxGetString(ssGetSFcnParam(S,0),fxname,sizeof(fxname));
    mexPrintf("Invoking %s with %d inputs, %d params\n",fxname,ninputs,nparams);
    mxArray ** plhs = (mxArray **)calloc((noutputs),sizeof(mxArray*));
    mxArray ** prhs = (mxArray **)calloc((3+nparams),sizeof(mxArray*)); // phase shapesin shapetype params..
    if(!plhs || !prhs)
    {
        ssSetErrorStatus(S,"failed calloc of inputs/params");                
        goto cleanup;
    }
    prhs[0] = mxCreateDoubleScalar(phase);
    prhs[1] = mxCreateCellMatrix(1,ninputs);
    prhs[2] = mxCreateCellMatrix(1,ninputs);
    for(int j = 0; j < ninputs; j++)
    {
        int ndims = ssGetInputPortNumDimensions(S,j);
        if(ndims < 0)
            goto cleanup;
        {
            mexPrintf("\tcall setup using input %d with ndims %d\n",j,ndims);
            int_T * idims = ssGetInputPortDimensions(S,j);
            mxArray * q = mxCreateDoubleMatrix(1,ndims,mxREAL);
            if(!q)
            {
                ssSetErrorStatus(S,"failed mxCreateDoubleMatrix");                
                goto cleanup;                
            }
            real_T * p = mxGetPr(q);
            for(i = 0; i < ndims; i++)
                p[i] = idims[i];
            mxSetCell(prhs[1],j,q);
        }
        {
            mxClassID cid = mxDOUBLE_CLASS;
            DTypeId  did = ssGetInputPortDataType(S,j);
            switch(did)
            {
                case -1: cid = mxDOUBLE_CLASS;break;
                case SS_DOUBLE: cid = mxDOUBLE_CLASS; break;
                case SS_SINGLE: cid = mxSINGLE_CLASS; break;
                case SS_INT32: cid = mxINT32_CLASS; break;
                case SS_UINT32: cid = mxUINT32_CLASS; break;
                case SS_INT16: cid = mxINT16_CLASS; break;
                case SS_UINT16: cid = mxUINT16_CLASS; break;
                case SS_INT8: cid = mxINT8_CLASS; break;
                case SS_UINT8: cid = mxUINT8_CLASS; break;
                case SS_BOOLEAN: cid = mxLOGICAL_CLASS; break;
                //case SS_INT64: cid = mxINT64_CLASS; break;
                default:
                    ssSetErrorStatus(S,"not implemented sim to mat typemap");                
                    goto cleanup;
                    break;
            }
            mxSetCell(prhs[2],j,mxCreateNumericMatrix(1,1,cid,mxREAL));
         }
    }
    
    // pass-through arguments
    for(i = 0; i < nparams; i++)
        prhs[i+3] = (mxArray*)ssGetSFcnParam(S,i); // pass
    mexCallMATLAB(noutputs,plhs,3+nparams,prhs,fxname);
    
    // phase 1 means DATA
    switch(phase)
    {
        case 2:
        {
            for(i = 0; i < noutputs; i++)
            {
                if(plhs[i])
                {
                    // generic type
                    real_T *y0 = ssGetOutputPortSignal(S,i);
                    int av = ssGetOutputPortWidth(S,i); // numelements
                    int n = mxGetNumberOfElements(plhs[i]);
                    void * pa = mxGetData(plhs[i]);
                    memcpy(y0,pa,mxGetElementSize(plhs[i])*(av < n ? av : n)); // min
                }
            }
            break;
        }
        case 0:
        {
            for(i = 0; i < noutputs; i++)
            {
                if(plhs[i])
                {
                    int32_T nDim;
                    int32_T *dims;
                    int32_T nDims = mxGetNumberOfElements(plhs[i]);
                    if(nDims != 0)
                    {
                        real_T * p = mxGetPr(plhs[i]);
                        DECL_AND_INIT_DIMSINFO(di); /* Initializes structure */
                        di.width   = 1; // compute in-line
                        di.numDims = (int32_T)nDims;
                        dims = (int32_T*) malloc(di.numDims*sizeof(int32_T));
                        for (nDim = 0; nDim < di.numDims; nDim++){
                            dims[nDim] = (int32_T)(p[nDim]);
                            di.width *= dims[nDim];
                        }
                        di.dims = &(dims[0]);
                        mexPrintf("setting ssSetOutputPortDimensionInfo phase:%d idx:%d numel:%d dims:%d\n",phase,i,di.width,di.numDims);
                        ssSetOutputPortDimensionInfo(S,i,&di);
                        free(dims); // is allowed?
                     }
                }
            }
            break;         
        }
        case 1: // type
        {
            for(i = 0; i < noutputs; i++)
            {
                if(plhs[i])
                {
                    mxClassID cid = mxGetClassID(plhs[i]);
                    DTypeId did = SS_SINGLE;
                    switch(cid)
                    {
                        case mxSINGLE_CLASS: did = SS_SINGLE; break;
                        case mxDOUBLE_CLASS: did = SS_DOUBLE; break;
                        //case mxINT64_CLASS:  did = SS_INT64; break;
                        case mxINT32_CLASS:  did = SS_INT32; break;
                        case mxUINT32_CLASS:  did = SS_UINT32; break;
                        case mxLOGICAL_CLASS: did = SS_BOOLEAN; break;
                        case mxINT8_CLASS:  did = SS_INT8; break;
                        case mxUINT8_CLASS:  did = SS_UINT8; break;
                        case mxINT16_CLASS:  did = SS_INT16; break;
                        case mxUINT16_CLASS:  did = SS_UINT16; break;
                        
                        default:
                            ssSetErrorStatus(S,"not implemented mat to sim typemap");
                            break;
                    }
                    ssSetOutputPortDataType(S,i,did);
                }
            }
            break;                     
        }
    }
cleanup:
    mxDestroyArray(prhs[0]);
    mxDestroyArray(prhs[1]);
    mxDestroyArray(prhs[2]);
    free(prhs);
    free(plhs);
    
}

/* Function: mdlOutputs =======================================================
 * Abstract:
 *   The mdlOutputs function will be called once with a tid == CONSTANT_TID
 *   if any of the sample times are constant. (Note that only blocks with
 *   a constant sample time on one or more ports will have the mdlOutputs
 *   function called with tid == CONSTANT_TID.)
 *
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    if (tid == CONSTANT_TID) {
        
        mexPrintf("mdlOutputs CONSTANT EVAL\n");
        callandsolve(S,2);
        mexPrintf("mdlOutputs CONSTANT DONE\n");
        
    }
} /* end mdlOutputs */

/* Function: mdlTerminate =====================================================
 * Abstract:
 *    Nothing to be done here.
 */
static void mdlTerminate(SimStruct *S)
{
}


#if defined(MATLAB_MEX_FILE)
#define MDL_SET_INPUT_PORT_DIMENSION_INFO
/* Function: mdlSetInputPortDimensionInfo ====================================
 * Abstract:
 *    This routine is called with the candidate dimensions for an input port
 *    with unknown dimensions. If the proposed dimensions are acceptable, the
 *    routine should go ahead and set the actual port dimensions.
 *    If they are unacceptable an error should be generated via
 *    ssSetErrorStatus.
 *    Note that any other input or output ports whose dimensions are
 *    implicitly defined by virtue of knowing the dimensions of the given port
 *    can also have their dimensions set.
 */
static void mdlSetInputPortDimensionInfo(SimStruct        *S,
        int_T            port,
        const DimsInfo_T *dimsInfo)
{
    mexPrintf("mdlSetInputPortDimensionInfo port %d\n",port);
    ssSetInputPortDimensionInfo(S,port,dimsInfo);
    //if(port == ssGetNumInputPorts(S))
    {
        mexPrintf("mdlSetInputPortDimensionInfo invoke Matlab\n");
        callandsolve(S,0);
        mexPrintf("mdlSetInputPortDimensionInfo exited Matlab\n");
    }
} /* end mdlSetInputPortDimensionInfo */

# define MDL_SET_OUTPUT_PORT_DIMENSION_INFO
/* Function: mdlSetOutputPortDimensionInfo ===================================
 * Abstract:
 *    This routine is called with the candidate dimensions for an output port
 *    with unknown dimensions. If the proposed dimensions are acceptable, the
 *    routine should go ahead and set the actual port dimensions.
 *    If they are unacceptable an error should be generated via
 *    ssSetErrorStatus.
 *    Note that any other input or output ports whose dimensions are
 *    implicitly defined by virtue of knowing the dimensions of the given
 *    port can also have their dimensions set.
 */
static void mdlSetOutputPortDimensionInfo(SimStruct        *S,
        int_T            port,
        const DimsInfo_T *dimsInfo)
{
    mexPrintf("mdlSetOutputPortDimensionInfo port %d\n",port);
    //  ssSetErrorStatus(S, "not accepted");
//    if(!ssSetOutputPortDimensionInfo(S, port, dimsInfo)) return;
    
} /* end mdlSetOutputPortDimensionInfo */

# define MDL_SET_DEFAULT_PORT_DIMENSION_INFO
/* Function: mdlSetDefaultPortDimensionInfo ====================================
 *    This routine is called when Simulink is not able to find dimension
 *    candidates for ports with unknown dimensions. This function must set the
 *    dimensions of all ports with unknown dimensions.
 */
static void mdlSetDefaultPortDimensionInfo(SimStruct *S)
{
    mexPrintf("mdlSetDefaultPortDimensionInfo\n");
    int n =ssGetNumOutputPorts(S);
    int i = 0;
    for(i = 0; i < n; i++)
    {
        int_T outWidth = ssGetOutputPortWidth(S, i);
        /* Input port dimension must be unknown. Set it to scalar. */
        if(!ssSetInputPortMatrixDimensions(S, i, 1, 1)) return;
        if(outWidth == DYNAMICALLY_SIZED){
            /* Output dimensions are unknown. Set it to scalar. */
            if(!ssSetOutputPortMatrixDimensions(S, i, 1, 1)) return;
        }
    }
    
} /* end mdlSetDefaultPortDimensionInfo */
#endif

#define MDL_SET_OUTPUT_PORT_DATA_TYPE
void mdlSetOutputPortDataType(SimStruct *S, int_T port,
 DTypeId id)
{
    // we use mdlSetInputPortDataType
}

#define MDL_SET_DEFAULT_PORT_DATA_TYPES
void mdlSetDefaultPortDataTypes(SimStruct *S)
{
}

#define MDL_SET_INPUT_PORT_DATA_TYPE
static void mdlSetInputPortDataType(SimStruct *S,int_T port,DTypeId dataID)
{
    ssSetInputPortDataType(S,port,dataID);
    {
        mexPrintf("mdlSetInputPortDataType invoke Matlab\n");
        callandsolve(S,1);
        mexPrintf("mdlSetInputPortDataType exited Matlab\n");
    }
    
}
/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
