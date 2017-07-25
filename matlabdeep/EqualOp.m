classdef EqualOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
        right
    end
    
    methods
        function obj = EqualOp(a,b)
            obj = obj@DeepOp();
            obj.left = a;
            obj.right = b;
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
            r = obj.xshape;
        end

        function grad(obj,up)
            warning('EqualOp gradient not implemented');
        end

        function gradshape(obj,up)
            warning('EqualOp gradient not implemented');
        end

         function reset(obj)
            obj.left.reset();
            obj.right.reset();
         end
        
    end
    
end

