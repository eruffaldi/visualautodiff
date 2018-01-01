classdef fromOpaque < matlab.System &  matlab.system.mixin.Propagates
    % untitled Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
  properties(Nontunable)
  end

    properties(DiscreteState)

    end

    % Pre-computed constants (setupImpl)
    properties(Access = private)
        outsize
        outtype
    end    

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            % executed AFTER
            t = propagatedInputDataType(obj,1);
            bu = evalin('base',t);
            [type,sizes] = decodeOpaqueTypeName(bu.Description);
             obj.outsize = sizes;
             obj.outtype = type;
        end

        function y = stepImpl(obj,u)
            % u is struct with .value as the opaque data (e.g. GPU)
            % create an output structure with field value sized accordingly
            % to the output size
            y.value = zeros(obj.outsize,obj.outtype);
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
        

        function out = getOutputSizeImpl(obj)
                out= 1;
        end

        function out = isOutputComplexImpl(obj)
          out = false;
        end

        function out = getOutputDataTypeImpl(obj)
            
             t = propagatedInputDataType(obj,1);
             if isempty(t)
                 disp([gcb ' getOutputDataTypeImpl - no type'])
             else
                out= strrep(strrep([gcb '_bus'],'/','_'),' ','_');
                 disp([gcb ' getOutputDataTypeImpl - with type'])
                 try
                     bu = evalin('base',t);
                 [type,sizes] = decodeOpaqueTypeName(bu.Description);
                 disp([gcb ' getOutputDataTypeImpl - with decoded ' type])
                 disp(sizes)
                 [~,out]= createWrapTypeBus(type,sizes,out);
                 catch me
                     disp([gcb ' getOutputDataTypeImpl - error'])
                     disp(me)
                 end
             disp([gcb ' getOutputDataTypeImpl - quit ' out])
             end
        end

    end
end
