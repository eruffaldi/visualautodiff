classdef Conv2dOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
        W
        stride
    end
    
    methods
        function obj = Conv2dOp(x,W,stride,pad)
            assert(all(stride==1),'only stride 1');
            assert(strcmp(pad,'SAME'),'only pad SAME');
            assert(isa(W,'Variable'),'W should be variable');
            obj = obj@DeepOp();
            obj.left = x;
            obj.W = W;
            obj.stride = stride;
        end
        
        function r = eval(obj)
            obj.left.eval();
            obj.xvalue = mzeros(obj.xshape);
            r = obj.xvalue;
        end
        
        function r = evalshape(obj)
            obj.xshape = obj.left.evalshape();
            r = obj.xshape;
        end
        
        function grad(obj,up)
            obj.left.grad(up);
        end
        
        function gradshape(obj,up)
            obj.left.gradshape(up);
        end
    end
    
end

