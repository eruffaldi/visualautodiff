function sfun_argmax(block)

  setup(block);
  
%endfunction

function setup(block)
  
  %% Register number of input and output ports
  block.NumInputPorts  = 1;
  block.NumOutputPorts = 1;
    
  block.OutputPort(1).SamplingMode = 'Sample';

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).DirectFeedthrough = true;
  
  %% Set block sample time to inherited
%  block.RegBlockMethod('SetOutputPortSampleTime',@DoSetOutputPortSampleTime);
 % block.RegBlockMethod('SetInputPortSampleTime',@DoSetInputPortSampleTime);
  block.RegBlockMethod('WriteRTW',                @WriteRTW);

%  block.SetAllowConstantSampleTime(true);
  block.SampleTimes = [-1,0];
 % block.OutputPort(1).SampleTime = [-1,0];
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


function DoPostPropSetup(block)

function Output(block)

     
[~,mi] = max(block.InputPort(1).Data,[],2);
block.OutputPort(1).Data =mi;

function SetInPortDims(block, idx, di)
    block.InputPort(idx).Dimensions = di;
if idx == 1
  block.OutputPort(1).Dimensions = di(1);
end

function WriteRTW(block)
  

%          v = block.InputPort(1).Dimensions;
%     n = v(1);
%     m = v(2);
%     d = m*n;
% 
%         
%         Tmn = zeros(d,d);
%     i = 1:d;
%     rI = 1+m.*(i-1)-(m*n-1).*floor((i-1)./n);
%     I1s = sub2ind([d d],rI,1:d);
%     Tmn(I1s) = 1;
%     Tmn = Tmn';
% 
%     
%   block.WriteRTWParam('matrix', 'Tmn', Tmn(:));

  
%endfunction

