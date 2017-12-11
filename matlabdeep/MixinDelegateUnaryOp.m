classdef(Abstract) MixinDelegateUnaryOp
    
    
    methods
        function r = eval(obj)
            r = obj.left.eval();            
        end
        
        function r = grad(obj,up)
            r = obj.left.grad(up);
        end 
        
        function r = evalshape(obj)
            obj.xshape = obj.left.evalshape();
            r = obj.xshape;
          end        
    end
end