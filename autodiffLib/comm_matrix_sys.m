classdef comm_matrix_sys < matlab.System & matlab.system.mixin.Propagates
    
    properties
    end
    
    properties(DiscreteState)
    end
    
    % Pre-computed constants
    properties(Nontunable, Access = private)
        C
    end
    
    methods(Access = protected)
        function setupImpl(obj)
            sz_1 = propagatedInputSize(obj,1);
            nl = prod(sz_1);
            I = reshape(1:nl, sz_1); % initialize a matrix of indices of size(A)
            I = I'; % Transpose it
            I = I(:); % vectorize the required indices
            Y = eye(nl); % Initialize an identity matrix
            Y = Y(I,:); % Re-arrange the rows of the identity matrix                       
            obj.C = Y;
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
            sz_1 = propagatedInputSize(obj,2);
        end
        
        function resetImpl(obj)
        end        
        
        function [JX] = stepImpl(obj,A,JY)
            JX = JY*obj.C;
        end
        
    end
end

