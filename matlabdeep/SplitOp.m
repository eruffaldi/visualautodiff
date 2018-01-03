%
% allows to use a sub-expression twice in the tree by collecting the
% gradient
%
classdef SplitOp < UnaryOp
    
    properties
    end
    
    methods
        function obj = SplitOp(a)
            obj = obj@UnaryOp(a);
            error('not yet');
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
        
        function grad(obj,ts)
            obj.left.grad(ts);
            obj.right.grad(ts);
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

