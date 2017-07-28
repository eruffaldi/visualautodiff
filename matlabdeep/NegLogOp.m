classdef NegLogOp < ElementWiseUnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = NegLogOp(a)
            obj = obj@ElementWiseUnaryOp(a);
        end
        
        function r = eval(obj)
            x = obj.left.eval();
            obj.xvalue = -log(x);
            r = obj.xvalue;
        end

        function r = evalshape(obj)
            obj.xshape = obj.left.evalshape();
            r = obj.xshape;
        end

        function grad(obj,up)
            obj.left.grad(-up ./max(obj.left.xvalue,1e-8));
        end

    end
    
end

