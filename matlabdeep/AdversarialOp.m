classdef AdversarialOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
    end
    
    methods
         function obj = AdversarialOp(left)
            obj = obj@DeepOp();
            obj.left = left;
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
         
          function gradshape(obj,up)
              obj.left.gradshape(up);
          end

    end
    
end
