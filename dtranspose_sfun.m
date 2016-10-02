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
  block.SampleTimes = [-1 0];
  
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Run accelerator on TLC
  block.SetAccelRunOnTLC(true);
  
  %% Register methods
  block.RegBlockMethod('Outputs',                 @Output);  
  
  block.RegBlockMethod('SetInputPortDimensions', @SetInPortDims);
  block.RegBlockMethod('PostPropagationSetup', @DoPostPropSetup);
  
%endfunction

function DoPostPropSetup(block)
  block.NumDworks = 1;
  
  block.Dwork(1).Name            = 'V';
  block.Dwork(1).DatatypeID      = 0;      % double
  block.Dwork(1).Complexity      = 'Real'; % real
  block.Dwork(1).UsedAsDiscState = false;
  block.Dwork(1).Usage = 'Scratch';
      
    v = block.InputPort(1).Dimensions;
    n = v(1);
    m = v(2);
    d = m*n;
    block.Dwork(1).Dimensions = [d,d];

    Tmn = zeros(d,d);
    i = 1:d;
    rI = 1+m.*(i-1)-(m*n-1).*floor((i-1)./n);
    I1s = sub2ind([d d],rI,1:d);
    Tmn(I1s) = 1;
    Tmn = Tmn';

    block.Dwork(1).Data = Tmn;
  

  
function Output(block)

  block.OutputPort(1).Data = block.Dwork(1).Data;

function SetInPortDims(block, idx, di)
  
    if length(di) == 1
        n = di(1);
    else
        n = di(1)*di(2);
    end
  block.OutputPort(1).Dimensions = [n,n];
  block.InputPort(idx).Dimensions    = di;


%endfunction

