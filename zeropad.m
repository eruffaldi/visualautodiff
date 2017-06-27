function zeropad(block)
% Level-2 MATLAB file S-Function.
%  Takes a scalar input and outputs a vector of length indicated 
% by its input value. The output is given by 1:n where n is the input
% value.
% For example
%  f(5) = [1 2 3 4 5]
%
% The parameter defines the maximum input value allowed.
%
%   Copyright 2009 The MathWorks, Inc.

setup(block);

function setup(block)

% Register number of ports and parameters
block.NumInputPorts  = 3;
block.NumOutputPorts = 1;
block.NumDialogPrms  = 0;

% Setup functional port properties to dynamically inherited
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Register the properties of the input port
block.InputPort(1).Complexity        = 'Inherited';
block.InputPort(1).DataTypeId        = -1;
block.InputPort(1).SamplingMode      = 'Sample';
block.InputPort(1).DimensionsMode    = 'Fixed';
block.InputPort(1).DirectFeedthrough = true;

block.InputPort(2).Complexity        = 'Inherited';
block.InputPort(2).DataTypeId        = -1;
block.InputPort(2).SamplingMode      = 'Sample';
block.InputPort(2).DimensionsMode    = 'Fixed';
block.InputPort(2).DirectFeedthrough = true;

block.InputPort(3).Complexity        = 'Inherited';
block.InputPort(3).DataTypeId        = -1;
block.InputPort(3).SamplingMode      = 'Sample';
block.InputPort(3).DimensionsMode    = 'Fixed';
block.InputPort(3).DirectFeedthrough = true;


% Register the properties of the output port
block.OutputPort(1).DimensionsMode = 'Fixed';
block.OutputPort(1).SamplingMode   = 'Sample';
block.OutputPort(1).Dimensions =  [6,3]; % [elemy,elemx];

% Register sample times
%  [-1, 0] : Inherited sample time
block.SampleTimes = [-1 0];

% Register methods called during update diagram/compilation
block.RegBlockMethod('SetInputPortDimensions',      @SetInputPortDims);
block.RegBlockMethod('PostPropagationSetup',        @DoPostPropSetup);

% Register methods called at run-time
block.RegBlockMethod('Outputs', @Outputs);

% -------------------------------------------------------------------------
function SetInputDimsMode(block, port, dm)
% Set dimension mode
block.InputPort(port).DimensionsMode = dm;

% -------------------------------------------------------------------------
function SetInputPortDims(block, idx, di)
width = prod(di);
if width < 1  
     DAStudio.error('Simulink:blocks:zeropad'); 
end
% Set compiled dimensions 
block.InputPort(idx).Dimensions = di;


gdims = block.InputPort(2).Dimensions;
ydims = block.InputPort(3).Dimensions;

%elemy = ydims(1);
%elemx = prod(gdims(2:end));
%if idx == 2
%end

% -------------------------------------------------------------------------
function DoPostPropSetup(block)
% Set the type of signal size to be dependent on input values, i.e.,
% dimensions have to be updated at output
block.SignalSizesComputeType = 'FromInputSize';

% -------------------------------------------------------------------------
function Outputs(block)
% Output function:
% -update output values
% -update signal dimensions
%
% TODO: block.InputPort(2).DataTypeId
w = zeros(block.OutputPort(1).Dimensions,block.OutputPort(1).DataType);
index1 = block.InputPort(1).Data;
w(index1:index1+block.InputPort(2).Dimensions(1)-1,:) = block.InputPort(2).Data;
block.OutputPort(1).Data = w;
