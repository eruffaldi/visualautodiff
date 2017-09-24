classdef ReluGradient_sys < matlab.System & matlab.system.mixin.Propagates
    % untitled2 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties

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

        function  [p1] = isOutputFixedSizeImpl(obj)
            p1 = true;         
        end
        
        function [p1] = getOutputDataTypeImpl(obj)
            p1 = propagatedInputDataType(obj,1);
        end

        function [p1] = isOutputComplexImpl(obj)
            p1 = false;
        end
            
        function [sz_1] = getOutputSizeImpl(obj) 
            sz_1 = propagatedInputSize(obj,1); % J 
        end
        

        function JX = stepImpl(obj,X,JY)
            JX = JY .* (X > 0);
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
