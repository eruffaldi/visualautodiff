classdef HardSigmoidOp < UnaryOp
      
    properties
        gd
    end
    methods
        function obj = HardSigmoidOp(a)
            obj = obj@UnaryOp(a);
        end
        
        function r = eval(obj)
            % if x < -2.5, 1. if x > 2.5. In -2.5 <= x <= 2.5, returns 0.2 * x + 0.5.
            x = obj.left.eval();
            gd = mzeros(obj.xshape,x);
            gd(x <= 2.5 & x >= -2.5) = 1.0;
            obj.gd = gd;
            r = max(min(x,2.5),-2.5) * 0.2 + 0.5;
        end

        function grad(obj,up)
            obj.left.grad(up .* obj.gd);
        end

    end
    
end

