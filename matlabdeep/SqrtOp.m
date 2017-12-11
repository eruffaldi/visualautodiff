classdef SqrtOp < ElementWiseUnaryOp
      
    methods
        function obj = SqrtOp(a)
            obj = obj@ElementWiseUnaryOp(a);
        end
        
        function r = eval(obj)
            obj.xvalue = sqrt(obj.left.eval());
            r = obj.xvalue;
        end

        function grad(obj,up)   
            % out = sqrt(X)
            % grad = 0.5 / sqrt(X)
            obj.left.grad(up.*(0.5 ./ obj.xvalue));
        end

    end
    
end

