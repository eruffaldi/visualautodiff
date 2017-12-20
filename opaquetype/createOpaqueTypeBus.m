% [r,n] = createOpaqueTypeBus(single(0),[1,2,32])
function [r,oname] = createOpaqueTypeBus(type,sizes)

name = encodeOpaqueTypeName(type,sizes);


%elems(1) = Simulink.BusElement;
%elems(1).Name = name; % first field encodes type
%elems(1).Dimensions = 1;
%elems(1).DimensionsMode = 'Fixed';
%elems(1).DataType = 'uint32';
%elems(1).SampleTime = -1;
%elems(1).Complexity = 'real';
i=1;
elems(i) = Simulink.BusElement;
elems(i).Name = 'value';
elems(i).Dimensions = 2;
elems(i).DimensionsMode = 'Fixed';
elems(i).DataType = 'uint32';
elems(i).SampleTime = -1;
elems(i).Complexity = 'real';

r = Simulink.Bus;
r.Description = name;
r.Elements = elems;
oname = [name,'_bus'];
assignin('base',oname,r);
