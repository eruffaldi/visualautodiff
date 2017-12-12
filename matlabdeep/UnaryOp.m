classdef UnaryOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
    end
    
    methods
         function obj = UnaryOp(left)
            obj = obj@DeepOp();
            obj.left = left;
         end
        
         function reset(obj)
             obj.left.reset();
         end
         
         function r = evalshape(obj)
            obj.xshape = obj.left.evalshape();
            r = obj.xshape;
         end
         
         function visit(obj,fx)
             if fx(obj) == 0
                 return;
             end
             obj.left.visit(fx);
         end
         
            
        function gradshape(obj,up)
            obj.left.gradshape(up);
        end
     
    end
    
end
