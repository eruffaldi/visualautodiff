classdef ArgmaxSystemD2 < matlab.System  & matlab.system.mixin.Propagates

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
                            sz_1 = [s(1),1];
        end
        
         function resetImpl(obj)
         end
      
        
        function [y] = stepImpl(obj,x)
           [~,y] = max(x,[],2);
        end
       
    end
end
