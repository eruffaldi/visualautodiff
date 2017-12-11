classdef MulOp < ElementwiseBinaryOp

    
    methods
        function obj = MulOp(a,b)
            obj = obj@ElemntwiseBinaryOp(a,b);
        end
        
        function r = eval(obj)
            xl = obj.left.eval() ;
            xr = obj.right.eval();
            r = obj.upsizemul(xl,xr);
            obj.xvalue = r;
        end

        % (up * b, up .* a)
        function grad(obj,up)
            assert(all(size(obj.left.xvalue)==size(up)));
            obj.left.grad( obj.upsizemul(up,obj.right.xvalue));            
            obj.right.grad(obj.downsizesum(up) .* obj.right.xvalue);
        end


    end
    
end

