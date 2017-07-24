classdef AddOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
        right
    end
    
    methods
        function obj = AddOp(a,b)
            obj = obj@DeepOp();
            obj.left = a;
            obj.right = b;
        end
        
        function r = eval(obj)
            xl = obj.left.eval() ;
            xr = obj.right.eval();
            sxl = size(xl);
            if ndims(xl) == ndims(xr)+1
                obj.xvalue = xl + repmat(xr,size(xl,1));
            elseif sxl(end) == size(xr,1)
                obj.xvalue = xl + squeeze(repmat(xr,size(xl,1)));
            else
                obj.xvalue = xl+xr;
            end
            r = obj.xvalue;
        end

        function r = evalshape(obj)
            ox = obj.right.evalshape();
            obj.xshape = obj.left.evalshape();
            r = obj.xshape;
        end

        function grad(obj,up)
            obj.left.grad(up);
            obj.right.grad(up);
        end

        function gradshape(obj,up)
            obj.left.gradshape(up);
            obj.right.gradshape(up);
        end

         function reset(obj)
            obj.left.reset()
            obj.right.reset();
         end
        
    end
    
end

