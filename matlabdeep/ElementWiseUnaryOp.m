classdef ElementWiseUnaryOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
         function obj = ElementWiseUnaryOp(left)
            obj = obj@UnaryOp(left);
         end

          function r = evalshape(obj)
            obj.xshape = obj.left.evalshape();
            r = obj.xshape;
          end
                 
        function gradshape(obj,ts)
            obj.left.gradshape(ts);
        end
    end
    
end
