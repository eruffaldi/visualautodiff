classdef ReshapeSystem < matlab.System  & matlab.system.mixin.Propagates
   
    properties(Nontunable)
        shape;
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Nontunable,Access = private)
        oshape
    end

    methods(Access = protected)
        function setupImpl(obj)
 

            obj.oshape = obj.getOutputSizeImpl();
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
            s = propagatedInputSize(obj,1); 
            % -1 -1 == 2D with first as first
            if length(obj.shape) == 2 & all(obj.shape == -1)
                %ROMAJOR sz_1 = [s(1), prod(s(2:end))];
                sz_1 = [prod(s(1:end-1)),s(end)];
            % -1 == all 1D
            elseif length(obj.shape) == 1 & obj.shape == -1
                sz_1 = prod(s);
            else
                % fixed exception optionally the first dimension
                sz_1 = obj.shape;
                if obj.shape(1) == -1
                    % row-major
                    sz_1(1) = s(1);
                elseif obj.shape(end) == -1
                    sz_1(end) = s(end);
                end
            end
        end
        
         function resetImpl(obj)
         end
      
        
        function [y] = stepImpl(obj,x)
            y = reshape(x,obj.getOutputSize()); 
            %y = zeros(obj.oshape,'like',x);
            %y(:) = x(:);
        end
       
    end
end
