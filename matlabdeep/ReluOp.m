classdef ReluOp < ElementWiseUnaryOp
    
    properties
    end
    
    methods
        function obj = ReluOp(a)
            obj = obj@ElementWiseUnaryOp(a);
        end
        
        function r = eval(obj)
            r = obj.left.eval();
            obj.xvalue = max(r,0);
            r = obj.xvalue;
        end

        function r = evalshape(obj)
            obj.xshape = obj.left.evalshape();
            r = obj.xshape;
        end

        function grad(obj,up)
            x = obj.left.xvalue;
            % Copyright vl_nn
            obj.left.grad(up .* (x > 0));
        end

    end
    
end

