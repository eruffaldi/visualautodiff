classdef reshapebug_sys < matlab.System & matlab.system.mixin.Propagates
    % untitled Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties(Nontunable)
        myshape
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Nontunable, Access = private)
        xshape
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.xshape = obj.myshape;
        end

        function y = stepImpl(obj,u)
            %Even if obj.xshape is produced via a Nontunable parameter this
            %not works
            y = reshape(u,obj.xshape);
            
            % The following works
            %y = reshape(u,obj.getOutputSize());
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
            
        function [sz_1] = getOutputSizeImpl(obj) 
            sz_1 = obj.myshape;
        end
    end
end
