classdef ReshapeSystem < matlab.System  & matlab.system.mixin.Propagates
    properties
        shape;
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)
    end

    methods(Access = protected)
        function setupImpl(obj)
 

            
        end

        function  [p1] = isOutputFixedSizeImpl(obj)
            p1 = true;
         
        end
        
            function [p1] = getOutputDataTypeImpl(obj)
                p1 = propagateInputType(obj,1);
            end
            
            function [p1] = isOutputComplexImpl(obj)
                p1 = false;
            end
            
        function [sz_1] = getOutputSizeImpl(obj) 
            s = propagatedInputSize(obj,1); 
            sz_1 = obj.shape;
            if obj.shape(1) == -1
                sz_1(1) = s(1);
            end
        end
        
         function resetImpl(obj)
         end
      
        
        function [y] = stepImpl(obj,x)
           y = reshape(y,obj.shape);
        end
       
    end
end
