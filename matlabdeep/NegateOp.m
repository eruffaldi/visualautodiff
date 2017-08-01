classdef NegateOp < ElementWiseUnaryOp
    
    properties
    end
    
    methods
        function obj = NegateOp(a)
            obj = obj@ElementWiseUnaryOp(a);
        end
        
        function r = eval(obj)
            r = obj.left.eval();
            obj.xvalue = -r;
            r = obj.xvalue;
        end

        function r = evalshape(obj)
            obj.xshape = obj.left.evalshape();
            r = obj.xshape;
        end

        function grad(obj,up)
            obj.left.grad(-up);
        end

    end
    
end

