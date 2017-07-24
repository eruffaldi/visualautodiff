classdef Conv2dOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x
        W
        stride
    end
    
    methods
        function obj = Conv2dOp(x,W,stride,pad)
            assert(all(stride==1),'only stride 1');
            assert(strcmp(pad,'SAME'),'only pad SAME');
            obj = obj@DeepOp();
            obj.x = x;
            obj.W = W;
            obj.stride = stride;
        end
        
        function r = eval(obj)
        end
        
        function r = evalshape(obj)
        end
        
        function grad(obj,up)
        end
        
        function gradshape(obj,up)
        end
    end
    
end

