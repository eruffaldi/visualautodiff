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

    % Pre-computed constants
    properties(Access = private)

    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

        function y = stepImpl(obj,u)
            y = 0;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
        

        function out = getOutputSizeImpl(obj)
            t = propagatedInputDataType(obj,1);
            if isempty(t)
                out= 1;
            else
                [type,sizes] = decodeOpaqueTypeName(t);
             out = sizes;
            end
        end

        function out = isOutputComplexImpl(obj)
          out = false;
        end

        function out = getOutputDataTypeImpl(obj)
            t = propagatedInputDataType(obj,1);
            if isempty(t)
                out= [];
            else
                [type,sizes] = decodeOpaqueTypeName(t);
             out = type;
            end
        end

    end
end
