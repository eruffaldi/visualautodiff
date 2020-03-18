classdef biunflatten_sys < matlab.System & matlab.system.mixin.Propagates
    % untitled2 Add summary here
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

        function y = stepImpl(obj,x,A,B)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            y = reshape(x,[size(A),size(B)]);
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
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

        % outputs mask and y are same size
        function [sz_y] = getOutputSizeImpl(obj) 
            sz_x =  propagatedInputSize(obj,1); 
            sz_a =  propagatedInputSize(obj,2); 
            sz_b =  propagatedInputSize(obj,3);
            sz_y = [sz_a,sz_b];
        end
                
    end
end
