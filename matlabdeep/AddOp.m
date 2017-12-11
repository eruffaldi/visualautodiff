classdef AddOp < ElementwiseBinaryOp 

    
    methods
        function obj = AddOp(a,b)
            obj = obj@ElementwiseBinaryOp(a,b);
        end
       

        function r = eval(obj)
            xl = obj.left.eval() ;
            xr = obj.right.eval();
            r = obj.upsizesum(xl,xr);
            obj.xvalue = r;
        end

        function grad(obj,up)
            assert(all(size(obj.left.xvalue)==size(up)));
            obj.left.grad(up);
            obj.right.grad(obj.downsizesum(up));
        end

    end
    
end

