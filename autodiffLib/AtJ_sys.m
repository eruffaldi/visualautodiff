classdef AtJ_sys < matlab.System & matlab.system.mixin.Propagates
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
            s1 = propagatedInputSize(obj,1); % J 
            s2 = propagatedInputSize(obj,2); % A
            sz_1 =  [s2(2) s1(2)];
        end
        

        function y = stepImpl(obj,J,A)
            y = A'*J;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
