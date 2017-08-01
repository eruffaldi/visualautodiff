classdef ReshapeGradSystem < matlab.System  & matlab.system.mixin.Propagates
    properties
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
            sz_1 = propagatedInputSize(obj,1); 
        end
        
         function resetImpl(obj)
         end
      
        
        function [y] = stepImpl(obj,x,J)
           y = reshape(J,size(x));
        end
       
    end
end
