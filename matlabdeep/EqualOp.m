classdef EqualOp < ElementWiseBinaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = EqualOp(a,b)
            obj = obj@BinaryOp(a,b);
        end
        
        function r = eval(obj)
            xl = obj.left.eval() ;
            xr = obj.right.eval();
            obj.xvalue = xl == xr;
            r = obj.xvalue;
        end

        function r = evalshape(obj)
            ox = obj.right.evalshape();
            obj.xshape = obj.left.evalshape();
            assert(all(obj.xshape==ox),'same shape');
            r = obj.xshape;
        end

        function grad(obj,up)
            error('EqualOp gradient not implemented');
        end

         function reset(obj)
            obj.left.reset();
            obj.right.reset();
         end
        
    end
    
end

