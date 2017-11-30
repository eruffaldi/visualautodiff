function dtranspose_sfun(block)
% Level-2 MATLAB file S-Function for times two demo.
%   Copyright 1990-2009 The MathWorks, Inc.

  setup(block);
  
%endfunction

function setup(block)
  
  %% Register number of input and output ports
  block.NumInputPorts  = 1;
  block.NumOutputPorts = 1;
    
  
  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).DirectFeedthrough = true;
  
  %% Set block sample time to inherited
  block.RegBlockMethod('SetOutputPortSampleTime',@DoSetOutputPortSampleTime);
  block.RegBlockMethod('SetInputPortSampleTime',@DoSetInputPortSampleTime);
  block.RegBlockMethod('WriteRTW',                @WriteRTW);

  block.SetAllowConstantSampleTime(true);
%  block.SampleTimes = inf;
  block.OutputPort(1).SampleTime = [inf,0];
%  block.SampleTimes = [-1,0];
%  block.OutputPort(1).SampleTime = [-1,0];
  
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Run accelerator on TLC
  block.SetAccelRunOnTLC(true);
  
  %% Register methods
  block.RegBlockMethod('Outputs',                 @Output);  
  
  block.RegBlockMethod('SetInputPortDimensions', @SetInPortDims);
  block.RegBlockMethod('PostPropagationSetup', @DoPostPropSetup);
%endfunction

function DoSetOutputPortSampleTime(block,port,time)
 block.OutputPort(port).SampleTime = time;
 %end SetOutputPortSampleTime
 
function DoSetInputPortSampleTime(block,port,time)
 block.InputPort(port).SampleTime = time;
  block.OutputPort(1).SampleTime = [inf,0];


function DoPostPropSetup(block)

function Output(block)

 if block.IsDoingConstantOutput
     
         v = block.InputPort(1).Dimensions;
    n = v(1);
    m = v(2);
    d = m*n;

        
        Tmn = zeros(d,d);
    i = 1:d;
    rI = 1+m.*(i-1)-(m*n-1).*floor((i-1)./n);
    I1s = sub2ind([d d],rI,1:d);
    Tmn(I1s) = 1;
    Tmn = Tmn';

    block.OutputPort(1).Data = Tmn;
 end

function SetInPortDims(block, idx, di)
  
    if length(di) == 1
        n = di(1);
    else
        n = di(1)*di(2);
    end
  block.OutputPort(1).Dimensions = [n,n];
  block.InputPort(idx).Dimensions    = di;

function WriteRTW(block)
  

         v = block.InputPort(1).Dimensions;
    n = v(1);
    m = v(2);
    d = m*n;

        
        Tmn = zeros(d,d);
    i = 1:d;
    rI = 1+m.*(i-1)-(m*n-1).*floor((i-1)./n);
    I1s = sub2ind([d d],rI,1:d);
    Tmn(I1s) = 1;
    Tmn = Tmn';

    
  block.WriteRTWParam('matrix', 'Tmn', Tmn(:));

  
%endfunction

