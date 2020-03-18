classdef biones_sys < matlab.System & matlab.system.mixin.Propagates
    % biones: creates a ones matrix with rows as number of elements of inputs and cols as number 
    % of elements of otput
    %

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

        function y = stepImpl(obj,A,B)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            y = ones(numel(A),numel(B));
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
        
        function  [p1] = isOutputFixedSizeImpl(obj)
            p1 = true;
         
        end
        
        function [p1] = getOutputDataTypeImpl(obj)
            p1 = 'double';
        end

        function [p1] = isOutputComplexImpl(obj)
            p1 = false;
        end

        % outputs mask and y are same size
        function [sz_y] = getOutputSizeImpl(obj) 
            sz_a =  propagatedInputSize(obj,1); 
            sz_b =  propagatedInputSize(obj,2);
            sz_y = [prod(sz_a),prod(sz_b)];
        end
                
    end
end
