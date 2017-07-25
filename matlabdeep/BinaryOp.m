classdef BinaryOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
        right
    end
    
    methods
        function obj = BinaryOp(a,b)
            obj = obj@DeepOp();
            obj.left = a;
            obj.right = b;
        end

         function visit(obj,fx)
             if fx(obj) == 0
                 return;
             end
             obj.left.visit(fx);
             obj.right.visit(fx);
         end
       
         function reset(obj)
            obj.left.reset()
            obj.right.reset();
         end

          function gradshape(obj,up)
            obj.left.gradshape(up);
            obj.right.gradshape(up);
        end
    end
    
end

