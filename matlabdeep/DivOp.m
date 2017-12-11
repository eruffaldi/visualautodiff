classdef DivOp < ElemntwiseBinaryOp

    
    methods
        function obj = DivOp(a,b)
            obj = obj@ElemntwiseBinaryOp(a,b);
        end
        
        function r = eval(obj)
            xl = obj.left.eval() ;
            xr = obj.right.eval();
            r = obj.upsizediv(xl,xr);
            obj.xvalue = r;
        end
    
        % diff(a/b,a) = 1/b
        % diff(a/b,b) = -a/b^2
        function grad(obj,up)
            assert(all(size(obj.left.xvalue)==size(up)));
            obj.left.grad( obj.upsizediv(up,obj.right.xvalue));            
            obj.right.grad(-obj.downsizesum(up.*a) ./ (obj.right.xvalue).^2);
        end


    end
    
end

