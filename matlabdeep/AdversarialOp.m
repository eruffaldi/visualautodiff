classdef AdversarialOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
    end
    
    methods
         function obj = AdversarialOp(left)
            obj = obj@UnaryOp(left);
         end
        
          function r = eval(obj)
             obj.xvalue = obj.left.eval();
             r = obj.value;
          end
         
          function r = evalshape(obj)
              obj.xshape = obj.left.evalshape();
              r = obj.xshape;
          end

          function grad(obj,up)
              obj.left.grad(-up);
          end
     
    end
    
end
