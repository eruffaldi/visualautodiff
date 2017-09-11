classdef ArgmaxSystemD2 < matlab.System  & matlab.system.mixin.Propagates

    properties(DiscreteState)
        t
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

        function [sz,dt,cp] = getDiscreteStateSpecificationImpl(obj,name)
            % Return size, data type, and complexity of discrete-state
            % specified in name
            sz = propagatedInputSize(obj,1);
            dt = 'double';
            cp = false;
        end
        
            function [p1] = getOutputDataTypeImpl(obj)
                p1 = 'single'; %propagatedInputDataType(obj,1);
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
           %[~,obj.t] = max(x,[],2);
           %y = single(obj.t);
           [~,y] =  max(x,[],2);
           y = single(y-1);
        end
       
    end
end
