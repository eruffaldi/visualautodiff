classdef ArgmaxSystem < matlab.System  & matlab.system.mixin.Propagates
    properties
        dim = 1;
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
                p1 = 'double';
            end
            
            function [p1] = isOutputComplexImpl(obj)
                p1 = false;
            end
            
        function [sz_1] = getOutputSizeImpl(obj) 
            s = propagatedInputSize(obj,1); 
            assert(prod(s) > 0);
            if obj.dim == 1
                sz_1 = [1,s(2)];
            else
                sz_1 = [s(2),1];
            end
        end
        
         function resetImpl(obj)
         end
      
        
        function [y] = stepImpl(obj,x)
           [~,y] = max(x,[],obj.dim);
        end
       
    end
end
