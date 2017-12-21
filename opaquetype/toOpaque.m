classdef toOpaque < matlab.System &  matlab.system.mixin.Propagates
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
     OutputBus; 

    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

        function y = stepImpl(obj,u)
            y.value = [1,2];
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
        

        function out = getOutputSizeImpl(obj)
            
                out = 1;
        end

        function out = isOutputComplexImpl(obj)
          out = false;
        end

        function out = getOutputDataTypeImpl(obj)
            t = propagatedInputDataType(obj,1);
            s = propagatedInputSize(obj,1);
            disp([gcb 'getOutputDataTypeImpl'])
            if isempty(t)
                disp('*no t');
                out = [];
                return;
            end
            if isempty(s)
                disp('*no s');
                out = [];
                return;
            end
            disp(t)
            disp(s)
           [~,oname]= createOpaqueTypeBus(t,s);
            out = oname;
        end

    end
end
