classdef SquareOp < VectorwiseUnaryOp
      
    methods
        function obj = SquareOp(a)
            obj = obj@ElementWiseUnaryOp(a);
        end
        
        function r = eval(obj)
            obj.xvalue = obj.left.eval().^2;
            r = obj.xvalue;
        end

        function grad(obj,up)   
            % let pass only the one passed otherwise 0
            obj.left.grad(up .* (2 * obj.xvalue));
        end

    end
    
end

