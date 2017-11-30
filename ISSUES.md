- reshape is not working when changing size (coder.varsize is not effective not doing y(:) = ...)
    make reshapeAuto s-function for both Function and Gradient
    should cost NOTHING due to the buffer reuse
        int_T ssGetInputPortBufferDstPort(SimStruct *S, int_T inputPortIdx)
        void ssSetInputPortOverWritable(SimStruct *S, int_T port, int_T
    e.g. starting from sfunddg_cb_edit('sdotproduct');
        
- conv2d/setup
    size change somewhere, unknown

- conv2d/value
    idem
