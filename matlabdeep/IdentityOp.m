classdef IdentityOp < UnaryOp
      
    methods
        function obj = IdentityOp(a)
            obj = obj@UnaryOp(a);
        en
        
        function r = eval(obj)
            obj.xvalue = obj.left.eval();
            r = obj.xvalue;
        end

        function grad(obj,up)
            obj.left.grad(up);
        end

    end
    
end

