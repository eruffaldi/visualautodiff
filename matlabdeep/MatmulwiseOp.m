classdef MatmulwiseOp < BinaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = MatmulwiseOp(a,b)
            obj = obj@BinaryOp(a,b);
        end
        
        function r = eval(obj)
            xl = obj.left.eval() ;
            xr = obj.right.eval();
            
            obj.xvalue = xl.*xr;
            r = obj.xvalue;
        end

         function r = evalshape(obj)
             xl = obj.left.evalshape();
             xr = obj.right.evalshape();
             assert(length(xl) == length(xr) & all(xl == xr));
             r = xl.xshape;
             obj.xshape = r;
        end

        function grad(obj,up)
             obj.left.grad(up .* obj.right.xvalue);
             obj.right.grad(up .* obj.left.xvalue);            
        end
        
    end
    
end

