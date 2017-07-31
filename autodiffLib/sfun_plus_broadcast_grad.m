function sfun_plus_broadcast_grad(block)

  setup(block);
  
%endfunction

function setup(block)
  
  %% Register number of input and output ports
  block.NumInputPorts  = 3;
  block.NumOutputPorts = 1;
  block.InputPort(1).SamplingMode = 'Sample';
  block.InputPort(2).SamplingMode = 'Sample';
  block.InputPort(3).SamplingMode = 'Sample';
  block.OutputPort(1).SamplingMode = 'Sample';
  
  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).DirectFeedthrough = true;
  block.InputPort(2).DirectFeedthrough = true;
  block.InputPort(3).DirectFeedthrough = true;
  
  %% Set block sample time to inherited
%  block.RegBlockMethod('SetOutputPortSampleTime',@DoSetOutputPortSampleTime);
 % block.RegBlockMethod('SetInputPortSampleTime',@DoSetInputPortSampleTime);
  block.RegBlockMethod('SetInputPortSamplingMode',@DoSetInputPortSamplingMode);
  block.RegBlockMethod('WriteRTW',                @WriteRTW);

  block.SampleTimes = [-1,0];
 % block.SetAllowConstantSampleTime(true);
%  block.SampleTimes = inf;
%  block.OutputPort(1).SampleTime = [-1,0];
% block.OutputPort(2).SampleTime = [-1,0];
 % block.SampleTimes = [-1,0];

  
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Run accelerator on TLC
  block.SetAccelRunOnTLC(true);
  
  %% Register methods
  block.RegBlockMethod('Outputs',                 @Output);  
  
  block.RegBlockMethod('SetInputPortDimensions', @SetInPortDims);
  block.RegBlockMethod('PostPropagationSetup', @DoPostPropSetup);
%endfunction

function DoSetInputPortSamplingMode(block,idx,mode)

block.InputPort(idx).SamplingMode = mode;
block.OutputPort(1).SamplingMode = mode;

function DoPostPropSetup(block)

function Output(block)

     
sxl = block.InputPort(1).Dimensions;
up = block.InputPort(3).Data;
w = [prod(sxl(1:end-1)) sxl(end)]; % cache
block.OutputPort(1).Data = sum(reshape(up,w),1);


function SetInPortDims(block, idx, di)
        block.InputPort(idx).Dimensions = di;

if idx == 2
  block.OutputPort(1).Dimensions = di;
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

