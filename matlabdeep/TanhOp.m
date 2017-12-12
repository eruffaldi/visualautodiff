classdef TanhOp < UnaryOp
      
    methods
        function obj = TanhOp(a)
            obj = obj@UnaryOp(a);
        end
        
        function r = eval(obj)
            obj.xvalue = tanh(obj.left.eval());
            r = obj.xvalue;
        end

        function grad(obj,up)
            % diff(tanh(x),x) == 1-tanh(x)^2
            obj.left.grad(up .* (1 - obj.xvalue.^2));
        end

    end
    
end

