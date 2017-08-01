classdef ReluOp < ElementWiseUnaryOp
      
    methods
        function obj = ReluOp(a)
            obj = obj@ElementWiseUnaryOp(a);
        end
        
        function r = eval(obj)
            obj.xvalue = max(obj.left.eval(),0);
            r = obj.xvalue;
        end

        function grad(obj,up)
            % let pass only the one passed otherwise 0
            obj.left.grad(up .* (obj.left.xvalue > 0));
        end

    end
    
end

