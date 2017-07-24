classdef MatmulOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
        right
    end
    
    methods
        function obj = MatmulOp(a,b)
            obj = obj@DeepOp();
            obj.left = a;
            obj.right = b;
        end
        
        function r = eval(obj)
            xl = obj.left.eval() ;
            xr = obj.right.eval();
            obj.xvalue = xl*xr;
            r = obj.xvalue;
        end

         function r = evalshape(obj)
             xl = obj.left.evalshape();
             xr = obj.right.evalshape();
             r = [xl(1:end-1),xr(2:end)];
        end

        function grad(obj,up)
            warning('not implemented MatmulOp grad');
            obj.left.grad(up);
            obj.right.grad(up);            
        end
        
        function gradshape(obj,up)
            obj.left.gradshape(up);
            obj.right.gradshape(up);
        end

        function reset(obj)
            obj.left.reset();
            obj.right.reset();
        end

    end
    
end

