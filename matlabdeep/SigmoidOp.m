classdef TanhOp < UnaryOp
      
    properties
        tmpexp
    end
    methods
        function obj = TanhOp(a)
            obj = obj@UnaryOp(a);
        end
        
        function r = eval(obj)
            tmpexp = exp(-obj.left.eval());
            obj.xvalue = 1./(1 + tmpexp);
            r = obj.xvalue;
        end

        function grad(obj,up)
            % diff(1/(1+exp(-x)),x) == exp(-x)/(exp(-x) + 1)^2
            obj.left.grad(up .* (tmpexp./((tmpexp+1).^2)));
        end

    end
    
end

