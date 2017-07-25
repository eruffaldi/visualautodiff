classdef SplitOp < BinaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
        right
    end
    
    methods
        function obj = SplitOp(a,b)
            obj = obj@BinaryOp(a,b);
        end
        
        function r = eval(obj)
            obj.xvalue = obj.left.eval();
            obj.right.eval(); % ignored
            r = obj.xvalue;
        end
        
        function r = evalshape(obj)
            obj.xshape = obj.left.evalshape();
            obj.right.evalshape();
            r = obj.xshape;
        end
        
        function grad(obj,up)
            obj.left.grad(up);
            obj.right.grad(up);
        end
        
        function gradshape(obj)
            obj.left.gradshape();
            obj.right.gradshape();
        end
        
        function reset(obj)
            obj.left.reset();
            obj.right.reset();
         end
        
    end
end
    
end

