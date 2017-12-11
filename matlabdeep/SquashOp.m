classdef SquashOp < VectorwiseWiseUnaryOp & MixinDelegateUnaryOp
      
    methods
        function obj = SquashOp(x,axis)
            s_squared_norm = ReduceSumOp(SquareOp(x),axis,1); % ||x||^2 along axis axis
            scale = s_squared_norm / (s_squared_norm + 1) / Sqrt(s_squared_norm + eps);
            % THIS uses broadcast of dimension axis
            obj = scale * x;
        end
       
    end
    
end

